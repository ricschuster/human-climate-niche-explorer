# /// script
# requires-python = ">=3.11"
# dependencies = ["numpy", "scipy", "pandas", "geopandas", "pyogrio", "shapely", "exactextract", "openpyxl"]
# ///
"""Check the processed data against the paper and the authors' data deposit.

Run from the repo root after the build scripts:
`uv run scripts/validate.py`

Exits with status 1 if any check fails. Checks:

1. Fig. 3a points: per-model hot exposure equals the authors' mat29.mat.
2. Fig. 3 regression coefficients and r2 as printed in the figure captions.
3. Numbers quoted in the paper's text (Figs. 2 and 3), at the paper's rounding.
4. Fig. 5: the country method with World Borders 0.3 reproduces the authors'
   country spreadsheet, country by country.
5. Fig. 5 with Natural Earth (the published table): totals within 0.5%.
6. Niche curves: the reference curve has the shape of the authors' Extended
   Data Fig. 1 reference (a loose check: that curve came from an earlier
   study's pipeline and differs in scale by up to about 10%).
"""

from __future__ import annotations

import sys

import numpy as np
import pandas as pd
import scipy.io

import build_countries as bc
import build_niche_curves as bn
import hcn_common as h

results: list[tuple[bool, str, str]] = []


def check(ok: bool, name: str, detail: str = "") -> None:
    results.append((bool(ok), name, detail))


def close(name: str, got: float, want: float, tol: float, unit: str = "") -> None:
    check(abs(got - want) <= tol, name, f"got {got:.4g}{unit}, paper {want:g}{unit} (tolerance {tol:g})")


def read(name: str) -> pd.DataFrame:
    path = h.PROCESSED / name
    if not path.exists():
        raise SystemExit(f"{path} missing: run the build scripts first (see scripts/README.md)")
    return pd.read_csv(path)


def fig3a_points(models: pd.DataFrame) -> None:
    dep = scipy.io.loadmat(h.FIG3A_MAT)
    x = np.ravel(dep["xwarming_used"])
    hot = models[models.metric == "hot"]
    total_95 = float(np.nansum(h.load("POP_S2_70")))
    total_111 = float(np.nansum(h.load("POP_S3_70")))
    for key, var, rescale in (
        ("6.9bn", "y_mat29_7billion_percent", 1.0),
        ("9.5bn", "y_mat29_9billion_percent", 1.0),
        # The authors divide the 11.1 billion counts by the 9.5 billion total
        # (Fig3a_Extend8_Exposed_MAT_Felt.m); we use the 11.1 billion total.
        ("11.1bn", "y_mat29_11billion_percent", total_111 / total_95),
    ):
        want = np.ravel(dep[var])
        got = hot[hot.population == key].sort_values(["warming", "model"])
        same_x = np.allclose(got.warming.to_numpy(), x)
        diff = np.max(np.abs(got.pct.to_numpy() * rescale - want)) if same_x else np.inf
        # mat29.mat holds the values to about 5 significant digits.
        check(
            same_x and diff < 1e-4,
            f"Fig. 3a points, {key} (65 model runs)",
            f"max difference {diff:.2g} percentage points",
        )


def fig3_fits(fits: pd.DataFrame) -> None:
    f = fits.set_index(["population", "metric"])
    # Fig. 3 captions: coefficient in % per C (1 decimal) and r2 (2 decimals).
    expected = {
        ("6.9bn", "hot"): (11.9, 0.83),
        ("9.5bn", "hot"): (13.8, 0.83),
        ("6.9bn", "outside_combined"): (11.0, 0.83),
        ("9.5bn", "outside_combined"): (9.5, 0.84),
        ("11.1bn", "outside_combined"): (9.1, 0.84),
    }
    for (pop, metric), (slope, r2) in expected.items():
        row = f.loc[(pop, metric)]
        close(f"Fig. 3 slope, {metric}, {pop}", row.slope_pct_per_c, slope, 0.05, " %/C")
        close(f"Fig. 3 r2, {metric}, {pop}", row.r2, r2, 0.005)
    # 11.1 billion hot: the paper's 17.5 uses the 9.5 billion denominator.
    total_ratio = float(np.nansum(h.load("POP_S3_70")) / np.nansum(h.load("POP_S2_70")))
    row = f.loc[("11.1bn", "hot")]
    close("Fig. 3 slope, hot, 11.1bn (authors' denominator)", row.slope_pct_per_c * total_ratio, 17.5, 0.05, " %/C")


def paper_text(summary: pd.DataFrame, ssp: pd.DataFrame) -> None:
    def w(level: float, metric: str, pop: str = "9.5bn") -> pd.Series:
        return summary[(summary.population == pop) & (summary.warming == level) & (summary.metric == metric)].iloc[0]

    def s(name: str, year: int, metric: str) -> pd.Series:
        return ssp[(ssp.ssp == name) & (ssp.year == year) & (ssp.metric == metric)].iloc[0]

    pct, bn = 0.5, 0.05  # half a unit of the paper's rounding
    # Fig. 2, 2010 baseline: 0.9 +/- 0.4% (62 +/- 26 million); 9 +/- 1%, 10 +/- 1%; 624 +/- 70 M.
    r = s("Observed", 2010, "hot")
    close("2010 hot exposure, %", r.pct_mean, 0.9, 0.05, "%")
    close("2010 hot exposure, sd", r.pct_sd, 0.4, 0.05, "%")
    close("2010 hot exposure, million", r.people_mean / 1e6, 62, 0.5)
    close("2010 hot exposure sd, million", r.people_sd / 1e6, 26, 0.5)
    r = s("Observed", 2010, "outside_temp")
    close("2010 outside niche (temperature), %", r.pct_mean, 9, pct, "%")
    close("2010 outside niche (temperature), million", r.people_mean / 1e6, 624, 0.5)
    close("2010 outside niche (temperature) sd, million", r.people_sd / 1e6, 70, 0.5)
    close("2010 outside niche (combined), %", s("Observed", 2010, "outside_combined").pct_mean, 10, pct, "%")
    # Fig. 2, SSP2-4.5.
    for year, metric, p, psd, b, bsd in (
        (2030, "hot", 4, 2, 0.3, 0.1),
        (2090, "hot", 23, 9, 2.1, 0.8),
        (2030, "outside_temp", 14, 3, 1.2, 0.2),
        (2090, "outside_temp", 29, 5, 2.7, 0.5),
        (2030, "outside_combined", 25, 2, 2.0, 0.2),
        (2090, "outside_combined", 40, 4, 3.7, 0.4),
    ):
        r = s("SSP2-4.5", year, metric)
        # The paper prints 25% for 24.46% (2030, combined), so allow 0.6 there.
        close(
            f"SSP2-4.5 {year} {metric}, %",
            r.pct_mean,
            p,
            0.6 if (year, metric) == (2030, "outside_combined") else pct,
            "%",
        )
        close(f"SSP2-4.5 {year} {metric}, sd", r.pct_sd, psd, pct, "%")
        close(f"SSP2-4.5 {year} {metric}, billion", r.people_mean / 1e9, b, bn)
        close(f"SSP2-4.5 {year} {metric} sd, billion", r.people_sd / 1e9, bsd, bn)
    # Fig. 2, range across SSPs in 2090.
    for metric, lo, hi, blo, bhi in (
        ("hot", 8, 40, 0.6, 4.7),
        ("outside_temp", 18, 47, 1.3, 4.7),
        ("outside_combined", 29, 53, 2.2, 6.5),
    ):
        g = ssp[(ssp.year == 2090) & (ssp.metric == metric)]
        close(f"2090 {metric} across SSPs, lowest %", g.pct_mean.min(), lo, pct, "%")
        close(f"2090 {metric} across SSPs, highest %", g.pct_mean.max(), hi, pct, "%")
        close(f"2090 {metric} across SSPs, lowest billion", g.people_mean.min() / 1e9, blo, bn)
        close(f"2090 {metric} across SSPs, highest billion", g.people_mean.max() / 1e9, bhi, bn)
    # Fig. 3, world of 9.5 billion. The paper converts percent to people with
    # a nominal 9.5 billion; the grid total is 9.46 billion, so allow 0.1.
    for level, metric, p, psd, b, bsd in (
        (3.6, "hot", 34, 10, 3.3, 0.9),
        (3.6, "outside_temp", 39, 7, 3.7, 0.7),
        (3.6, "outside_combined", 48, 7, 4.5, 0.6),
        (4.4, "hot", 45, 7, 4.2, 0.7),
        (4.4, "outside_temp", 47, 8, 4.5, 0.7),
        (4.4, "outside_combined", 55, 7, 5.3, 0.6),
        (2.7, "hot", 22, None, 2.1, None),
        (1.5, "hot", 5, None, 0.4, None),
        (2.7, "outside_temp", 29, None, 2.8, None),
        (1.5, "outside_temp", 14, None, 1.3, None),
        (2.7, "outside_combined", 39, None, 3.7, None),
        (1.5, "outside_combined", 28, None, 2.7, None),
    ):
        r = w(level, metric)
        # Known quirk: the paper prints 34% for 3.6 C hot exposure, where the
        # model mean is 34.7% (its 3.3 billion and sd do match).
        tol = 0.75 if (level, metric) == (3.6, "hot") else pct
        close(f"{level} C {metric} (9.5 billion), %", r.pct_mean, p, tol, "%")
        close(f"{level} C {metric} (9.5 billion), billion", r.people_mean / 1e9, b, 0.1)
        if psd is not None:
            close(f"{level} C {metric} (9.5 billion), sd", r.pct_sd, psd, pct, "%")
            close(f"{level} C {metric} (9.5 billion) sd, billion", r.people_sd / 1e9, bsd, 0.1)


# The paper's spreadsheet shortens some World Borders 0.3 names.
WB_TO_PAPER_NAMES = {
    "Burma": "Myanmar",
    "Congo": "Congo Republic",
    "Democratic Republic of the Congo": "Congo Democratic Republic",
    "Guinea-Bissau": "Guinea Bissau",
    "Iran (Islamic Republic of)": "Iran",
    "Korea, Democratic People's Republic of": "North Korea",
    "Korea, Republic of": "South Korea",
    "Lao People's Democratic Republic": "Laos",
    "Libyan Arab Jamahiriya": "Libya",
    "Micronesia, Federated States of": "Micronesia",
    "Republic of Moldova": "Moldova",
    "Syrian Arab Republic": "Syria",
    "The former Yugoslav Republic of Macedonia": "Macedonia",
    "United Republic of Tanzania": "Tanzania",
    "Viet Nam": "Vietnam",
}


def fig5_world_borders() -> None:
    wb = bc.read_boundaries(h.WORLD_BORDERS)
    cells = bc.assign_cells(wb, "worldborders")
    levels = [w for w in h.WARMING_LEVELS if w.level in (1.5, 2.7)]
    df = bc.country_exposure(wb, cells, levels, bc.POPS)
    df["Name"] = pd.Series(wb["NAME"].to_numpy()[df["row"]]).replace(WB_TO_PAPER_NAMES).to_numpy()
    paper = pd.read_excel(h.FIG5_XLSX, sheet_name="plain_data")
    columns = {
        "pop_9b_27C": (2.7, "exposed_9.5bn"),
        "pop_9b_15C": (1.5, "exposed_9.5bn"),
        "pop_11b_27C": (2.7, "exposed_11.1bn"),
        "pop_11b_15C": (1.5, "exposed_11.1bn"),
        "landfraction_27C": (2.7, "exposed_land_pct"),
        "landfraction_15C": (1.5, "exposed_land_pct"),
    }
    unmatched = sorted(set(paper.Name) - set(df.Name))
    check(len(unmatched) == 0, "Fig. 5 country names match World Borders", f"unmatched: {unmatched[:5]}")
    for col, (level, ours) in columns.items():
        mine = (
            df[df.warming == level].groupby("Name")[ours].sum()
            if "pct" not in ours
            else df[df.warming == level].groupby("Name")[ours].max()
        )
        joined = paper.set_index("Name")[col].to_frame("paper").join(mine.rename("ours"), how="inner")
        if "pct" in ours:
            diff = (joined.ours - joined.paper).abs()
            check(
                diff.max() <= 0.5,
                f"Fig. 5 {col}, every country within 0.5 points",
                f"max difference {diff.max():.3f} points ({diff.idxmax()})",
            )
        else:
            total_paper, total_ours = joined.paper.sum(), joined.ours.sum()
            diff = (joined.ours - joined.paper).abs()
            check(
                abs(total_ours - total_paper) < 0.5e6 and diff.max() < 0.5e6,
                f"Fig. 5 {col}, totals and every country within 0.5 million",
                f"total {total_ours / 1e6:.1f} M vs {total_paper / 1e6:.1f} M; worst country {diff.idxmax()} off by {diff.max() / 1e6:.2f} M",
            )


def fig5_natural_earth(countries: pd.DataFrame) -> None:
    totals = countries.groupby("warming")[["exposed_9.5bn", "exposed_11.1bn"]].sum() / 1e6
    for level, col, want in ((2.7, "exposed_9.5bn", 1997), (1.5, "exposed_9.5bn", 419), (2.7, "exposed_11.1bn", 2495)):
        got = totals.loc[level, col]
        check(
            abs(got / want - 1) < 0.005,
            f"Natural Earth total, {col} at {level} C, within 0.5% of the paper",
            f"{got:.0f} M vs {want} M",
        )


def niche_reference() -> None:
    ref = bn.ensemble(h.load("popden1980"), h.load("MAT6090"))
    theirs = scipy.io.loadmat(h.FIGDATA / "Extend_Fig1_newref.mat")["out_curpop6090_mat_curve"]
    ok = ~np.isnan(ref) & ~np.isnan(theirs)
    corr = min(np.corrcoef(ref[i][ok[i]], theirs[i][ok[i]])[0, 1] for i in range(ref.shape[0]))
    ratio = ref[ok] / theirs[ok]
    check(corr > 0.99, "Reference niche curve shape matches Extended Data Fig. 1", f"lowest correlation {corr:.4f}")
    check(
        0.85 < ratio.min() and ratio.max() < 1.1,
        "Reference niche curve scale within 15%",
        f"ratio {ratio.min():.3f} to {ratio.max():.3f}",
    )
    curves = read("niche_curves.csv")
    levels = set(curves[(curves.curve == "warming") & (curves.population == "9.5bn")].warming)
    want = {w.level for w in h.FUTURE_LEVELS}
    check(
        levels == want,
        "Niche curves present for every warming level (9.5 billion)",
        f"missing: {sorted(want - levels)}",
    )


def main() -> None:
    models = read("by_warming_models.csv")
    fig3a_points(models)
    fig3_fits(read("by_warming_fit.csv"))
    paper_text(read("by_warming_summary.csv"), read("by_ssp_year_summary.csv"))
    fig5_world_borders()
    fig5_natural_earth(read("countries_by_warming.csv"))
    niche_reference()

    width = max(len(n) for _, n, _ in results)
    for ok, name, detail in results:
        print(f"{'PASS' if ok else 'FAIL'}  {name:<{width}}  {detail}")
    failed = sum(not ok for ok, _, _ in results)
    print(f"\n{len(results) - failed} passed, {failed} failed")
    sys.exit(1 if failed else 0)


if __name__ == "__main__":
    main()
