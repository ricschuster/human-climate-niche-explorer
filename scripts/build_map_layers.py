# /// script
# requires-python = ">=3.11"
# dependencies = ["numpy", "scipy", "pillow"]
# ///
"""Map raster layers (Fig. 4, generalized to every warming level).

Run from the repo root: `uv run scripts/build_map_layers.py`

Writes to data/processed/map/:

- hot_<level>.png: cells whose ensemble-mean MAT is above 29 C at that warming
  level (the same cells the country table counts).
- population_light.png, population_dark.png: people per 1/12 degree cell
  (about 100 km2) in the 9.5 billion world (SSP2, 2070), in classes that are a
  subset of the paper's Fig. 4 legend. One file per page theme.
- layers.json: image corner coordinates for MapLibre, file names, classes and
  colours.

The images are reprojected to Web Mercator by nearest-neighbour row lookup
(columns are already linear in longitude), at full 1/12 degree resolution at
the equator. They are 8-bit palette PNGs; index 0 is transparent (sea).
"""

from __future__ import annotations

import json
import math

import numpy as np
from PIL import Image

import hcn_common as h

OUT = h.PROCESSED / "map"
MERCATOR_MAX_LAT = 85.0511287798066

# Upper bounds of each class (people per cell), from the paper's Fig. 4 breaks.
POP_BREAKS = [10, 100, 1_000, 10_000, 100_000, 1_000_000]
POP_LABELS = ["0-10", "11-100", "101-1,000", "1,001-10,000", "10,001-100,000", "100,001-1,000,000", "Over 1,000,000"]
# Single-hue blue sequential ramp (steps 100-700 of the reference palette).
# Light: near-zero recedes toward the light surface; dark: toward the dark one.
POP_COLORS_LIGHT = ["#cde2fb", "#9ec5f4", "#6da7ec", "#3987e5", "#256abf", "#184f95", "#0d366b"]
POP_COLORS_DARK = list(reversed(POP_COLORS_LIGHT))
HOT_COLOR = "#eb6834"


def hex_rgb(c: str) -> list[int]:
    return [int(c[i : i + 2], 16) for i in (1, 3, 5)]


def merc_y(lat: float) -> float:
    return math.log(math.tan(math.pi / 4 + math.radians(lat) / 2))


class Grid:
    """Places cell values on the global grid and reprojects rows to Web Mercator."""

    def __init__(self) -> None:
        self.row, self.col = h.grid_index(h.load("x"), h.load("y"))
        north = min(90 - self.row.min() / h.CELLS_PER_DEGREE, MERCATOR_MAX_LAT)
        south = max(90 - (self.row.max() + 1) / h.CELLS_PER_DEGREE, -MERCATOR_MAX_LAT)
        self.north, self.south = north, south
        yn, ys = merc_y(north), merc_y(south)
        height = round(h.GRID_COLS / (2 * math.pi) * (yn - ys))
        my = yn - (np.arange(height) + 0.5) / height * (yn - ys)
        lat = np.degrees(np.arctan(np.sinh(my)))
        self.src_rows = np.clip(np.floor((90 - lat) * h.CELLS_PER_DEGREE).astype(int), 0, h.GRID_ROWS - 1)

    def image(self, values: np.ndarray) -> np.ndarray:
        """uint8 palette indices per cell (0 = transparent) to a Mercator image array."""
        full = np.zeros((h.GRID_ROWS, h.GRID_COLS), dtype=np.uint8)
        full[self.row, self.col] = values
        return full[self.src_rows]

    def corners(self) -> list[list[float]]:
        return [[-180, self.north], [180, self.north], [180, self.south], [-180, self.south]]


def save_png(arr: np.ndarray, colors: list[str], name: str) -> str:
    img = Image.fromarray(arr, mode="P")
    palette = [0, 0, 0] + [v for c in colors for v in hex_rgb(c)]
    img.putpalette(palette)
    path = OUT / name
    img.save(path, optimize=True, transparency=0)
    print(f"wrote {path.relative_to(h.REPO)} ({path.stat().st_size / 1e3:.0f} KB)")
    return name


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    grid = Grid()

    pop = np.nan_to_num(np.asarray(h.load(h.REFERENCE_POPULATION.var)))
    classes = (np.searchsorted(POP_BREAKS, pop, side="left") + 1).astype(np.uint8)  # 1..7, 0 = sea
    pop_img = grid.image(classes)
    pop_files = {
        "light": save_png(pop_img, POP_COLORS_LIGHT, "population_light.png"),
        "dark": save_png(pop_img, POP_COLORS_DARK, "population_dark.png"),
    }

    hot_files = {}
    for w in h.WARMING_LEVELS:
        hot = (h.ensemble_mean(h.load(w.mat_var)) > h.HOT_THRESHOLD_C).astype(np.uint8)
        hot_files[f"{w.level}"] = save_png(grid.image(hot), [HOT_COLOR], f"hot_{w.level}.png")

    meta = {
        "coordinates": grid.corners(),
        "width": h.GRID_COLS,
        "height": len(grid.src_rows),
        "population": {
            "files": pop_files,
            "population": h.REFERENCE_POPULATION.label,
            "unit": "people per 1/12 degree cell (about 100 km2)",
            "classes": [
                {"label": lab, "color_light": cl, "color_dark": cd}
                for lab, cl, cd in zip(POP_LABELS, POP_COLORS_LIGHT, POP_COLORS_DARK, strict=True)
            ],
        },
        "hot": {
            "files": hot_files,
            "color": HOT_COLOR,
            "definition": "ensemble-mean MAT above 29 C",
        },
    }
    path = OUT / "layers.json"
    path.write_text(json.dumps(meta, indent=2) + "\n")
    print(f"wrote {path.relative_to(h.REPO)}")


if __name__ == "__main__":
    main()
