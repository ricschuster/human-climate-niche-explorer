# /// script
# requires-python = ">=3.11"
# dependencies = ["numpy", "scipy", "pandas"]
# ///
"""Global exposure tables: by warming level (Fig. 3) and by SSP and year (Fig. 2).

Run from the repo root: `uv run scripts/build_global.py`

Writes to data/processed/:

- warming_levels.csv: the warming levels, their SSP and period, policy label.
- by_warming_models.csv: one row per population, warming level, metric and
  climate model (the points of Fig. 3).
- by_warming_summary.csv: mean, sd, 5th and 95th percentiles per population,
  warming level and metric.
- by_warming_fit.csv: the linear regressions of Fig. 3 (slope, intercept, r2).
- by_warming_fit_curve.csv: fitted line and 95% confidence band, 0 to 5 C.
- by_ssp_year_summary.csv: Fig. 2, per SSP and 20-year period, with the 2010
  baseline.

Metrics:

- hot: people in cells with MAT above 29 C. Recomputed here from the grid.
- outside_temp: people left outside the niche by temperature change only.
- outside_combined: people left outside the niche by temperature plus
  demographic change.

The two outside-niche metrics are read from the authors' niche-displacement
results (nichedisplacement/1D/*.mat), which were produced with a Gaussian
niche fit per climate model (Fig2_3b_Displacement_Niche1D.m). They are not
recomputed here. People are percent times total population, as in the paper.
"""

from __future__ import annotations

import numpy as np
import pandas as pd
import scipy.io
import scipy.stats

import hcn_common as h

METRICS = {
    "hot": "Exposed to unprecedented heat (MAT above 29 C)",
    "outside_temp": "Left outside the niche, temperature change only",
    "outside_combined": "Left outside the niche, temperature and demographic change",
}
SOURCE_GRID = "recomputed from the authors' grid data"
SOURCE_DEPOSIT = "authors' niche-displacement results"

# Reference niche corresponds to 0.3 C warming (1960-1990); the authors force
# the outside-niche regressions through zero there (displace_regression.m).
NICHE_X_INTERCEPT = 0.3

DEPOSIT_POP_FILES = {"6.9bn": "pop69billion", "9.5bn": "pop95billion", "11.1bn": "pop112billion"}


def warming_levels_table() -> pd.DataFrame:
    rows = []
    for w in h.WARMING_LEVELS:
        mat = h.load(w.mat_var)
        rows.append(
            {
                "warming": w.level,
                "ssp": w.ssp or "Observed",
                "period": w.period,
                "policy": w.policy,
                "n_models": mat.shape[1],
                "mat_variable": w.mat_var,
            }
        )
    return pd.DataFrame(rows)


def load_deposit(path) -> dict[str, np.ndarray]:
    d = scipy.io.loadmat(path)
    return {k: np.ravel(v) for k, v in d.items() if not k.startswith("__")}


def deposit_file(prefix: str) -> h.Path:
    """Find a 1D displacement file ignoring case (the deposit mixes SSP2/ssp1)."""
    matches = [p for p in h.NICHE1D.iterdir() if p.name.lower() == f"{prefix}.mat".lower()]
    if len(matches) != 1:
        raise SystemExit(f"expected one file for {prefix} in {h.NICHE1D}, found {matches}")
    return matches[0]


def by_warming_models() -> pd.DataFrame:
    rows = []
    for pop in h.POPULATIONS:
        popv = h.load(pop.var)
        total = float(np.nansum(popv))
        # Hot exposure from the grid.
        for w in h.WARMING_LEVELS:
            exposed = h.hot_exposed(popv, h.load(w.mat_var))
            for i, people in enumerate(exposed):
                rows.append(
                    {
                        "population": pop.key,
                        "warming": w.level,
                        "metric": "hot",
                        "model": i + 1,
                        "pct": people / total * 100,
                        "people": people,
                    }
                )
        # Outside the niche from the authors' results (65 points in level order).
        dep = load_deposit(deposit_file(f"displace1Dresult_alldata_{DEPOSIT_POP_FILES[pop.key]}"))
        x = dep["warmingplotx"]
        for metric, key in (("outside_temp", "warmingplot_0to1_y"), ("outside_combined", "warmingplot_1to2_y")):
            for level in np.unique(x):
                vals = dep[key][x == level]
                for i, pct in enumerate(vals):
                    rows.append(
                        {
                            "population": pop.key,
                            "warming": float(level),
                            "metric": metric,
                            "model": i + 1,
                            "pct": pct,
                            "people": pct / 100 * total,
                        }
                    )
    return pd.DataFrame(rows)


def summarize_groups(df: pd.DataFrame, keys: list[str]) -> pd.DataFrame:
    out = []
    for group, g in df.groupby(keys, sort=False):
        row = dict(zip(keys, group if isinstance(group, tuple) else (group,), strict=True))
        for col in ("pct", "people"):
            for stat, v in h.summarize(g[col].to_numpy()).items():
                if stat == "n":
                    row["n_models"] = v
                else:
                    row[f"{col}_{stat}"] = v
        row["source"] = SOURCE_GRID if row.get("metric") == "hot" else SOURCE_DEPOSIT
        out.append(row)
    return pd.DataFrame(out)


def ols(x: np.ndarray, y: np.ndarray, intercept: bool, xv: np.ndarray):
    """Least squares like MATLAB fitlm, with predict()'s 95% curve confidence band."""
    X = np.column_stack([np.ones_like(x), x]) if intercept else x[:, None]
    Xv = np.column_stack([np.ones_like(xv), xv]) if intercept else xv[:, None]
    beta, *_ = np.linalg.lstsq(X, y, rcond=None)
    resid = y - X @ beta
    n, p = X.shape
    dof = n - p
    s2 = resid @ resid / dof
    cov = s2 * np.linalg.inv(X.T @ X)
    fit = Xv @ beta
    se = np.sqrt(np.einsum("ij,jk,ik->i", Xv, cov, Xv))
    t = scipy.stats.t.ppf(0.975, dof)
    # fitlm reports r2 about the mean even without an intercept term.
    ss_tot = ((y - y.mean()) ** 2).sum() if intercept else (y**2).sum()
    r2 = 1 - (resid @ resid) / ss_tot
    return beta, r2, fit, fit - t * se, fit + t * se


def fits(models: pd.DataFrame) -> tuple[pd.DataFrame, pd.DataFrame]:
    xv = np.round(np.arange(0.0, 5.0001, 0.05), 2)
    params, curves = [], []
    for (pop, metric), g in models.groupby(["population", "metric"], sort=False):
        x = g["warming"].to_numpy(float)
        y = g["pct"].to_numpy(float)
        if metric == "hot":
            # Fig3a_Extend8_Exposed_MAT_Felt.m: y ~ 1 + x
            beta, r2, fit, lo, hi = ols(x, y, True, xv)
            slope, intercept = beta[1], beta[0]
            note = "ordinary least squares"
        elif metric == "outside_temp":
            # displace_regression.m: y ~ -1 + (x - 0.3)
            beta, r2, fit, lo, hi = ols(x - NICHE_X_INTERCEPT, y, False, xv - NICHE_X_INTERCEPT)
            slope, intercept = beta[0], -beta[0] * NICHE_X_INTERCEPT
            note = "forced through zero at 0.3 C"
        else:
            # displace_regression.m: y ~ 1 + (x - 0.3)
            beta, r2, fit, lo, hi = ols(x - NICHE_X_INTERCEPT, y, True, xv - NICHE_X_INTERCEPT)
            slope, intercept = beta[1], beta[0] - beta[1] * NICHE_X_INTERCEPT
            note = "ordinary least squares on warming minus 0.3 C"
        params.append(
            {
                "population": pop,
                "metric": metric,
                "slope_pct_per_c": slope,
                "intercept_pct": intercept,
                "r2": r2,
                "n": len(x),
                "method": note,
            }
        )
        curves.append(
            pd.DataFrame({"population": pop, "metric": metric, "warming": xv, "fit": fit, "lo": lo, "hi": hi})
        )
    return pd.DataFrame(params), pd.concat(curves, ignore_index=True)


def by_ssp_year() -> pd.DataFrame:
    rows = []

    def add(ssp: str, year: int, popv: np.ndarray, mat: np.ndarray, dep_prefix: str):
        total = float(np.nansum(popv))
        hot = h.hot_exposed(popv, mat)
        dep = load_deposit(deposit_file(dep_prefix))
        series = {
            "hot": hot / total * 100,
            "outside_temp": dep["Outp_displace_0to1"],
            "outside_combined": dep["Outp_displace_1to2"],
        }
        for metric, pct in series.items():
            row = {"ssp": ssp, "year": year, "metric": metric, "total_population": total}
            for stat, v in h.summarize(pct).items():
                row["n_models" if stat == "n" else f"pct_{stat}"] = v
            for stat, v in h.summarize(pct / 100 * total).items():
                if stat != "n":
                    row[f"people_{stat}"] = v
            row["source"] = SOURCE_GRID if metric == "hot" else SOURCE_DEPOSIT
            rows.append(row)

    # 2010 baseline: 2010 population under 2000-2020 climate.
    add("Observed", 2010, h.load("popcount2010"), h.load("MAT0020"), "displace1Dresult_P69b_C10warm")
    for s, ssp in h.SSPS.items():
        for yy, year in h.YEARS.items():
            add(ssp, year, h.load(f"POP_S{s}_{yy}"), h.load(f"MAT_S{s}_{yy}"), f"displace1Dresult_ssp{s}_{year}")
    return pd.DataFrame(rows)


def main() -> None:
    h.write_csv(warming_levels_table(), "warming_levels.csv")
    models = by_warming_models()
    h.write_csv(models, "by_warming_models.csv")
    h.write_csv(summarize_groups(models, ["population", "warming", "metric"]), "by_warming_summary.csv")
    params, curves = fits(models)
    h.write_csv(params, "by_warming_fit.csv")
    h.write_csv(curves, "by_warming_fit_curve.csv")
    h.write_csv(by_ssp_year(), "by_ssp_year_summary.csv")


if __name__ == "__main__":
    main()
