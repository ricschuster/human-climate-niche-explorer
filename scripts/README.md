# Scripts

Preprocessing turns the authors' data deposit in `data/raw/` into the small
files in `data/processed/` that the site reads. Every processed file comes from
one of these scripts; see `data/processed/README.md` for what each file holds.

## Running

Needs [uv](https://docs.astral.sh/uv/) and the raw data:

```bash
./scripts/download_data.sh   # once, about 1.7 GB
./scripts/build_all.sh       # rebuild everything, then validate
```

Each script declares its own dependencies inline (PEP 723), so `uv run`
installs them on first use. Run a single step from the repo root, for example
`uv run scripts/build_global.py`.

The first run caches each grid variable from `displacement_data.mat` as a
`.npy` file, plus the cell-to-country lookups, in
`~/.cache/human-climate-niche-explorer/` (about 2.7 GB; set `HCN_CACHE` to
move it). The cache sits outside the repo on purpose. Delete it to force a
fresh read of the raw data.

## Steps

| Script | Reproduces | Writes |
| --- | --- | --- |
| `build_global.py` | Figs. 2 and 3 | `warming_levels.csv`, `by_warming_*.csv`, `by_ssp_year_summary.csv` |
| `build_niche_curves.py` | Fig. 1a, 1c, Extended Data Fig. 7 | `niche_curves.csv` |
| `build_countries.py` | Fig. 5, at every warming level | `countries_by_warming.csv`, `countries.geojson` |
| `build_map_layers.py` | Fig. 4, at every warming level | `map/*.png`, `map/layers.json` |
| `validate.py` | Checks all of the above against the paper | nothing; exits 1 on any failure |

`hcn_common.py` holds the shared constants (warming levels, populations,
threshold) and helpers. `download_data.sh` fetches the raw data and
`bootstrap-repo-settings.sh` is repo setup from the project template.

## Validation

`validate.py` runs about 100 checks and prints PASS or FAIL for each:

- the 65 per-model points of Fig. 3a equal the authors' `mat29.mat`;
- the Fig. 3 regression slopes and r2 match the captions;
- every number quoted in the paper's text for Figs. 2 and 3 matches at the
  paper's rounding;
- with World Borders 0.3, every country's exposed population and land fraction
  matches the authors' Fig. 5 spreadsheet;
- with Natural Earth (the published table), totals are within 0.5%;
- the reference niche curve has the shape of Extended Data Fig. 1.

Known differences from the paper, and why, are in
`docs/design/01_data_notes.md`.

## Lint

`uvx ruff check scripts && uvx ruff format --check scripts` (settings in
`ruff.toml`). CI runs the same.
