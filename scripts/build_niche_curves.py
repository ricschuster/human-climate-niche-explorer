# /// script
# requires-python = ">=3.11"
# dependencies = ["numpy", "scipy", "pandas"]
# ///
"""Niche curves: population density against MAT (Fig. 1a and 1c, Extended Data Fig. 7).

Run from the repo root: `uv run scripts/build_niche_curves.py`

Writes data/processed/niche_curves.csv with one row per curve and MAT window:

- reference: 1980 population density under 1960-1990 climate (the niche).
- current: 2010 population density under 2000-2020 climate.
- warming: a fixed population (6.9, 9.5 or 11.1 billion) under the MAT of
  each warming level.

Method, as in Fig1_Extend157_MAT_Niche.m: per climate model, normalize the
population weights to sum to 1e6, take the running mean of the weights in
2 C wide MAT windows stepped by 1 C from -5 C to 35 C, and drop windows with
fewer than 1000 cells. The ensemble curve is the mean across models (missing
if any model is missing) with the 5th and 95th percentiles. The y values are
relative (the paper's axis has no units). `mat` is the window centre; the
paper's Fig. 1 plots each window at its lower edge.
"""

from __future__ import annotations

import numpy as np
import pandas as pd

import hcn_common as h

NICHE_FACTOR = 1e6
MAT_START, MAT_END = -5, 35  # window lower edges, inclusive
WINDOW = 2
LEAST_SAMPLE = 1000
STARTS = np.arange(MAT_START, MAT_END + 1)


def running_mean(weights: np.ndarray, mat: np.ndarray) -> np.ndarray:
    """runningmeandata.m for one model: mean weight in [j, j + 2) for each start j."""
    ok = (weights >= 0) & ~np.isnan(mat)
    w = weights[ok]
    w = NICHE_FACTOR * w / w.sum()
    m = mat[ok]
    k = np.floor(m).astype(np.int64) - MAT_START  # unit bin index
    nbins = len(STARTS) + WINDOW - 1
    inside = (k >= 0) & (k < nbins)
    sums = np.bincount(k[inside], weights=w[inside], minlength=nbins)
    counts = np.bincount(k[inside], minlength=nbins)
    win_sum = sums[:-1] + sums[1:]
    win_n = counts[:-1] + counts[1:]
    with np.errstate(invalid="ignore", divide="ignore"):
        out = win_sum / win_n
    out[win_n < LEAST_SAMPLE] = np.nan
    return out


def ensemble(weights: np.ndarray, mat: np.ndarray) -> np.ndarray:
    """Running-mean curve for each model column: shape (models, windows)."""
    weights = np.nan_to_num(np.asarray(weights), nan=-1.0)  # NaN weights are dropped like MATLAB's >= 0 test
    mat2 = np.asarray(mat) if np.ndim(mat) == 2 else np.asarray(mat)[:, None]
    return np.vstack([running_mean(weights, np.asarray(mat2[:, i])) for i in range(mat2.shape[1])])


def curve_rows(curves: np.ndarray, **labels) -> list[dict]:
    mean = curves.mean(axis=0)  # NaN if any model is NaN, like MATLAB mean
    with np.errstate(invalid="ignore"):
        p5, p95 = np.nanpercentile(curves, [5, 95], axis=0, method="hazen")
    rows = []
    for j, start in enumerate(STARTS):
        if np.isnan(mean[j]):
            continue
        rows.append(
            {
                **labels,
                "mat": start + WINDOW / 2,
                "mat_lo": start,
                "mat_hi": start + WINDOW,
                "mean": mean[j],
                "p5": p5[j],
                "p95": p95[j],
                "n_models": curves.shape[0],
            }
        )
    return rows


def build() -> tuple[pd.DataFrame, dict[str, np.ndarray]]:
    rows: list[dict] = []
    per_model: dict[str, np.ndarray] = {}

    ref = ensemble(h.load("popden1980"), h.load("MAT6090"))
    per_model["reference"] = ref
    rows += curve_rows(
        ref, curve="reference", population="4.4bn", warming=0.3, label="1980 population, 1960-1990 climate"
    )
    cur = ensemble(h.load("popden2010"), h.load("MAT0020"))
    per_model["current"] = cur
    rows += curve_rows(
        cur, curve="current", population="6.9bn", warming=1.0, label="2010 population, 2000-2020 climate"
    )

    for pop in h.POPULATIONS:
        # popden2010 is the density version of the 6.9 billion world (Extended Data Fig. 7a).
        weights = h.load("popden2010") if pop.key == "6.9bn" else h.load(pop.var)
        for w in h.FUTURE_LEVELS:
            c = ensemble(weights, h.load(w.mat_var))
            per_model[f"{pop.key}_{w.level}"] = c
            rows += curve_rows(
                c, curve="warming", population=pop.key, warming=w.level, label=f"{pop.label}, {w.level} C"
            )
    return pd.DataFrame(rows), per_model


def main() -> None:
    df, _ = build()
    h.write_csv(df, "niche_curves.csv")


if __name__ == "__main__":
    main()
