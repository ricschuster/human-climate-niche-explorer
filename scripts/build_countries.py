# /// script
# requires-python = ">=3.11"
# dependencies = ["numpy", "scipy", "pandas", "geopandas", "pyogrio", "shapely", "exactextract"]
# ///
"""Country exposure per warming level (Fig. 5, generalized) and country shapes.

Run from the repo root: `uv run scripts/build_countries.py`

Method (docs/decisions/0004-country-aggregation-and-boundaries.md):

1. Average MAT across climate models (ensemble mean), then flag cells above
   29 C.
2. People: assign each 1/12 degree cell to the country polygon containing its
   centre. Cells in no polygon (mostly coastal) are dropped, as in the paper.
3. Land: exposed land area is the area of each country polygon covered by
   exposed cells (exact cell-polygon coverage fractions times the WGS84 cell
   area), so small islands with no cell centre inside still get an area.
   Exposed land fraction divides that by the polygon's area in an equal-area
   projection (EPSG:6933). Both reproduce the paper's Fig. 5 data.

Writes to data/processed/:

- countries_by_warming.csv: one row per country and warming level, with
  people exposed in worlds of 9.5 and 11.1 billion, exposed land area and
  fraction. Computed with Natural Earth borders, so even the 1.5 and 2.7 C
  rows differ slightly from the paper's Fig. 5 (mainly Sudan / South Sudan).
- countries.geojson: simplified Natural Earth country shapes for the map,
  keyed by `id` (ADM0_A3).
"""

from __future__ import annotations

import json

import geopandas as gpd
import numpy as np
import pandas as pd
import shapely
from exactextract import exact_extract
from exactextract.raster import NumPyRasterSource

import hcn_common as h

EQUAL_AREA = "EPSG:6933"
# Shapes are for display only (assignment uses full detail): about 5 km
# tolerance, about 1 km coordinate precision.
SIMPLIFY_DEG = 0.05
COORD_DECIMALS = 2
MIN_AREA_DEG2 = 0.002  # drop slivers and tiny islets from the display shapes only
POPS = {"9.5bn": "POP_S2_70", "11.1bn": "POP_S3_70"}


def read_boundaries(path) -> gpd.GeoDataFrame:
    if not path.exists():
        raise SystemExit(f"{path} not found: run ./scripts/download_data.sh first")
    gdf = gpd.read_file(path)
    return gdf.to_crs("EPSG:4326") if gdf.crs and gdf.crs.to_epsg() != 4326 else gdf


def assign_cells(gdf: gpd.GeoDataFrame, cache_name: str) -> np.ndarray:
    """Row index into gdf of the polygon containing each cell centre, -1 if none."""
    path = h.CACHE / f"cells_{cache_name}.npy"
    if path.exists():
        return np.load(path)
    x = np.asarray(h.load("x"))
    y = np.asarray(h.load("y"))
    points = shapely.points(x, y)
    tree = shapely.STRtree(gdf.geometry.values)
    pt_idx, poly_idx = tree.query(points, predicate="within")
    out = np.full(len(x), -1, dtype=np.int32)
    # A centre on a shared border can fall in two polygons: keep the first.
    order = np.argsort(pt_idx, kind="stable")
    pt_idx, poly_idx = pt_idx[order], poly_idx[order]
    first = np.r_[True, pt_idx[1:] != pt_idx[:-1]]
    out[pt_idx[first]] = poly_idx[first]
    h.CACHE.mkdir(parents=True, exist_ok=True)
    np.save(path, out)
    return out


def covered_area(
    gdf: gpd.GeoDataFrame, row: np.ndarray, col: np.ndarray, cell_area: np.ndarray, mask: np.ndarray
) -> np.ndarray:
    """km2 of each polygon covered by the masked cells (exact coverage fractions)."""
    grid = np.zeros((h.GRID_ROWS, h.GRID_COLS))
    grid[row[mask], col[mask]] = cell_area[mask]
    src = NumPyRasterSource(grid, xmin=-180, ymin=-90, xmax=180, ymax=90)
    polys = gpd.GeoDataFrame({"row": np.arange(len(gdf))}, geometry=gdf.geometry.values, crs="EPSG:4326")
    out = exact_extract(src, polys, ["sum"], include_cols=["row"], output="pandas")
    return out.set_index("row")["sum"].reindex(np.arange(len(gdf)), fill_value=0.0).to_numpy()


def country_exposure(gdf: gpd.GeoDataFrame, cells: np.ndarray, levels, pops: dict[str, str]) -> pd.DataFrame:
    """Per-country exposure for each warming level; columns keyed by population."""
    x = np.asarray(h.load("x"))
    y = np.asarray(h.load("y"))
    grow, gcol = h.grid_index(x, y)
    area = h.cell_area_km2(y)
    n = len(gdf)
    inside = cells >= 0
    idx = cells[inside]
    country_area = gdf.to_crs(EQUAL_AREA).area.to_numpy() / 1e6
    pop_arrays = {k: np.nan_to_num(np.asarray(h.load(v)))[inside] for k, v in pops.items()}
    totals = {k: np.bincount(idx, weights=p, minlength=n) for k, p in pop_arrays.items()}
    frames = []
    for w in levels:
        hot_all = h.ensemble_mean(h.load(w.mat_var)) > h.HOT_THRESHOLD_C
        hot = hot_all[inside]
        df = pd.DataFrame({"row": np.arange(n), "warming": w.level})
        for k, p in pop_arrays.items():
            df[f"exposed_{k}"] = np.bincount(idx[hot], weights=p[hot], minlength=n)
            df[f"population_{k}"] = totals[k]
        df["exposed_land_km2"] = covered_area(gdf, grow, gcol, area, hot_all)
        df["country_area_km2"] = country_area
        # Guard against rounding just above 100% for fully exposed countries;
        # the paper's Fig. 5 data also tops out at exactly 100 (Burkina Faso).
        df["exposed_land_pct"] = np.minimum(df["exposed_land_km2"] / country_area * 100, 100.0)
        frames.append(df)
    return pd.concat(frames, ignore_index=True)


def display_shapes(gdf: gpd.GeoDataFrame) -> dict:
    geoms = []
    for geom in gdf.geometry.values:
        parts = list(geom.geoms) if geom.geom_type == "MultiPolygon" else [geom]
        big = [p for p in parts if p.area >= MIN_AREA_DEG2] or [max(parts, key=lambda p: p.area)]
        g = shapely.simplify(
            shapely.MultiPolygon(big) if len(big) > 1 else big[0], SIMPLIFY_DEG, preserve_topology=True
        )
        geoms.append(shapely.set_precision(g, 10**-COORD_DECIMALS))
    out = gpd.GeoDataFrame({"id": gdf["ADM0_A3"].values, "name": gdf["ADMIN"].values}, geometry=geoms, crs="EPSG:4326")
    out = out[~out.geometry.is_empty]
    return json.loads(out.to_json(drop_id=True))


def main() -> None:
    ne = read_boundaries(h.NATURAL_EARTH)
    cells = assign_cells(ne, "naturalearth")
    df = country_exposure(ne, cells, h.WARMING_LEVELS, POPS)
    df.insert(0, "id", ne["ADM0_A3"].to_numpy()[df["row"]])
    df.insert(1, "iso3", ne["ISO_A3_EH"].to_numpy()[df["row"]])
    df.insert(2, "name", ne["ADMIN"].to_numpy()[df["row"]])
    df.insert(3, "continent", ne["CONTINENT"].to_numpy()[df["row"]])
    df = df.drop(columns="row")
    # Rows for levels the paper's Fig. 5 also reports (with older borders).
    df["paper_level"] = df["warming"].isin([1.5, 2.7])
    df = df.sort_values(["warming", "exposed_9.5bn"], ascending=[True, False])
    h.write_csv(df, "countries_by_warming.csv", float_format="%.6g")

    geo = display_shapes(ne)
    path = h.PROCESSED / "countries.geojson"
    path.write_text(json.dumps(geo, separators=(",", ":")))
    print(f"wrote {path.relative_to(h.REPO)} ({len(geo['features'])} features, {path.stat().st_size / 1e6:.2f} MB)")

    unassigned = np.nan_to_num(np.asarray(h.load("POP_S2_70")))[cells < 0].sum()
    print(f"cells outside every polygon hold {unassigned / 1e6:.0f} M of the 9.5 billion")


if __name__ == "__main__":
    main()
