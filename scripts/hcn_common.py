"""Shared constants and helpers for the preprocessing scripts.

Imported by the `build_*.py` and `validate.py` scripts in this folder, which
declare their own dependencies inline (PEP 723) and run with `uv run`. This
module itself needs only numpy and scipy.

Conventions taken from the authors' MATLAB code in `reference/authors_code/`:

- Hot exposure counts cells with MAT strictly greater than 29 degrees C
  (`nansum(pop(mat > 29))`), although the paper writes "29 degrees C or more".
- Uncertainty ranges are the 5th and 95th percentiles across climate models,
  computed like MATLAB's `prctile` (numpy method "hazen"). The paper's text
  quotes mean plus or minus one sample standard deviation (MATLAB `std`,
  ddof=1). Both are written to the processed files.
"""

from __future__ import annotations

import os
from dataclasses import dataclass
from pathlib import Path

import numpy as np

REPO = Path(__file__).resolve().parent.parent
RAW = REPO / "data" / "raw"
PROCESSED = REPO / "data" / "processed"
FIGDATA = RAW / "Data" / "Fig1_4_Extendfigs_Data"
GRID_MAT = FIGDATA / "displacement_data.mat"
NICHE1D = FIGDATA / "nichedisplacement" / "1D"
FIG5_XLSX = RAW / "Data" / "MAT29C_exposure_population_land_area__27c_15c_country(Fig 5 Data).xlsx"
FIG3A_MAT = RAW / "Data" / "Fig6_Data" / "mat29.mat"
NATURAL_EARTH = RAW / "boundaries" / "naturalearth" / "ne_10m_admin_0_countries.shp"
WORLD_BORDERS = RAW / "boundaries" / "worldborders" / "TM_WORLD_BORDERS-0.3.shp"

# Per-variable .npy cache of displacement_data.mat. Kept outside the repo on
# purpose: the repo sits in a synced folder and the cache is several GB.
CACHE = Path(os.environ.get("HCN_CACHE", Path.home() / ".cache" / "human-climate-niche-explorer"))

HOT_THRESHOLD_C = 29.0

# Grid: 1/12 degree, cell centres in x (lon) and y (lat).
CELLS_PER_DEGREE = 12
GRID_COLS = 360 * CELLS_PER_DEGREE  # 4320
GRID_ROWS = 180 * CELLS_PER_DEGREE  # 2160
# WGS84 ellipsoid, for exact cell areas.
WGS84_A_KM = 6378.137
WGS84_F = 1 / 298.257223563


@dataclass(frozen=True)
class WarmingLevel:
    level: float  # global warming above pre-industrial, degrees C
    mat_var: str  # ensemble MAT variable in displacement_data.mat
    ssp: str | None
    period: str
    policy: str  # short policy label from the paper, "" if none


# Paper Methods and authors' code (Fig2_3b_Displacement_Niche1D.m). 1.0 is the
# 2000-2020 observed climate ("present"), used in the regressions.
WARMING_LEVELS: list[WarmingLevel] = [
    WarmingLevel(1.0, "MAT0020", None, "2000-2020", "Present day"),
    WarmingLevel(1.5, "MAT_S1_30", "SSP1-2.6", "2021-2040", "Paris Agreement goal"),
    WarmingLevel(1.8, "MAT_S1_90", "SSP1-2.6", "2081-2100", "All announced targets met"),
    WarmingLevel(2.0, "MAT_S2_50", "SSP2-4.5", "2041-2060", ""),
    WarmingLevel(2.1, "MAT_S3_50", "SSP3-7.0", "2041-2060", "Binding long-term targets"),
    WarmingLevel(2.4, "MAT_S5_50", "SSP5-8.5", "2041-2060", "2030 NDCs only"),
    WarmingLevel(2.7, "MAT_S2_90", "SSP2-4.5", "2081-2100", "Current policies"),
    WarmingLevel(3.6, "MAT_S3_90", "SSP3-7.0", "2081-2100", "Worst case"),
    WarmingLevel(4.4, "MAT_S5_90", "SSP5-8.5", "2081-2100", "Worst case"),
]
FUTURE_LEVELS = [w for w in WARMING_LEVELS if w.level >= 1.5]


@dataclass(frozen=True)
class FixedPopulation:
    key: str  # used in file columns
    label: str
    var: str  # population count variable


# Fixed populations of Fig. 3 (paper Methods). 9.5 billion is the reference
# world used by every slider-driven view.
POPULATIONS: list[FixedPopulation] = [
    FixedPopulation("6.9bn", "6.9 billion (2010)", "popcount2010"),
    FixedPopulation("9.5bn", "9.5 billion (SSP2, 2070)", "POP_S2_70"),
    FixedPopulation("11.1bn", "11.1 billion (SSP3, 2070)", "POP_S3_70"),
]
REFERENCE_POPULATION = POPULATIONS[1]

SSPS = {"1": "SSP1-2.6", "2": "SSP2-4.5", "3": "SSP3-7.0", "5": "SSP5-8.5"}
YEARS = {"30": 2030, "50": 2050, "70": 2070, "90": 2090}  # 20-year period centres


def load(name: str) -> np.ndarray:
    """Load one variable from displacement_data.mat, via the .npy cache.

    Column vectors are returned 1-D; (cells, models) matrices stay 2-D.
    """
    CACHE.mkdir(parents=True, exist_ok=True)
    path = CACHE / f"{name}.npy"
    if not path.exists():
        import scipy.io

        if not GRID_MAT.exists():
            raise SystemExit(f"{GRID_MAT} not found: run ./scripts/download_data.sh first")
        arr = scipy.io.loadmat(GRID_MAT, variable_names=[name])[name]
        tmp = path.with_suffix(".tmp.npy")
        np.save(tmp, np.asarray(arr, dtype=np.float64))
        tmp.replace(path)
    arr = np.load(path, mmap_mode="r")
    return arr[:, 0] if arr.ndim == 2 and arr.shape[1] == 1 else arr


def percentiles(values: np.ndarray, axis: int = 0) -> tuple[np.ndarray, np.ndarray]:
    """5th and 95th percentiles, matching MATLAB `prctile`."""
    p5, p95 = np.percentile(values, [5, 95], axis=axis, method="hazen")
    return p5, p95


def summarize(values: np.ndarray) -> dict[str, float]:
    """Mean, sample sd, 5th and 95th percentiles, min, max and n of a 1-D array."""
    v = np.asarray(values, dtype=float)
    p5, p95 = percentiles(v)
    return {
        "mean": float(v.mean()),
        "sd": float(v.std(ddof=1)) if v.size > 1 else 0.0,
        "p5": float(p5),
        "p95": float(p95),
        "min": float(v.min()),
        "max": float(v.max()),
        "n": int(v.size),
    }


def hot_exposed(pop: np.ndarray, mat: np.ndarray) -> np.ndarray:
    """People in cells with MAT > 29 C, per model column (as in the authors' code)."""
    mat2 = mat if mat.ndim == 2 else mat[:, None]
    pop = np.nan_to_num(np.asarray(pop))
    return np.array([pop[np.asarray(mat2[:, i]) > HOT_THRESHOLD_C].sum() for i in range(mat2.shape[1])])


def ensemble_mean(mat: np.ndarray) -> np.ndarray:
    """Mean MAT across climate models (columns), ignoring NaN."""
    mat = np.asarray(mat)
    if mat.ndim == 1:
        return mat
    import warnings

    with warnings.catch_warnings():
        warnings.simplefilter("ignore", RuntimeWarning)  # all-NaN rows (no data) stay NaN
        return np.nanmean(mat, axis=1)


def grid_index(x: np.ndarray, y: np.ndarray) -> tuple[np.ndarray, np.ndarray]:
    """Row and column of each cell centre on the 4320 x 2160 global grid."""
    col = np.rint((np.asarray(x) + 180.0) * CELLS_PER_DEGREE - 0.5).astype(np.int32)
    row = np.rint((90.0 - np.asarray(y)) * CELLS_PER_DEGREE - 0.5).astype(np.int32)
    return row, col


def cell_area_km2(y: np.ndarray) -> np.ndarray:
    """Exact area of a 1/12 degree cell centred at latitude y on the WGS84 ellipsoid.

    Uses the closed form for the area of a band of latitude on an ellipsoid of
    revolution. Matches equal-area projected areas (e.g. EPSG:6933), which is
    how the paper's country land areas behave.
    """
    e2 = WGS84_F * (2 - WGS84_F)
    e = np.sqrt(e2)
    b2 = (WGS84_A_KM * (1 - WGS84_F)) ** 2
    half = 0.5 / CELLS_PER_DEGREE

    def q(lat_deg):
        s = np.sin(np.deg2rad(lat_deg))
        return s / (1 - e2 * s * s) + np.log((1 + e * s) / (1 - e * s)) / (2 * e)

    y = np.asarray(y, dtype=float)
    dlon = np.deg2rad(1.0 / CELLS_PER_DEGREE)
    return 0.5 * b2 * dlon * (q(y + half) - q(y - half))


def write_csv(df, name: str, float_format: str = "%.6g") -> Path:
    """Write a DataFrame to data/processed/ with stable float formatting."""
    PROCESSED.mkdir(parents=True, exist_ok=True)
    path = PROCESSED / name
    df.to_csv(path, index=False, float_format=float_format, lineterminator="\n")
    print(f"wrote {path.relative_to(REPO)} ({len(df)} rows)")
    return path
