# Static site with Observable Framework

## Status

Accepted

## Context

The primary audience is policy and NCC staff (see
`docs/design/00_project_brief.md`). They need a fast, shareable site with
linked views: one warming slider driving a map, charts and a country table.
Options considered:

- Static site with Observable Framework: linked reactive views, built-in
  Observable Plot and D3, MapLibre for maps, deploys to GitHub Pages.
- Quarto with Observable JS: also static, but more glue code for dashboard
  layouts and linked views.
- R Shiny: can recompute on the fly, but needs a hosted server, loads slower,
  and costs money or has usage limits for a public audience.

The full grid (about 1.7 GB) is far too large to ship to a browser, so any
option needs a preprocessing step either way.

## Decision

- Build the site with Observable Framework and deploy it to GitHub Pages.
- Preprocess the authors' `.mat` files with Python scripts in `scripts/`,
  run with `uv` (dependencies declared inline), writing small files (CSV,
  JSON, Parquet, PNG) to `data/processed/`.
- Commit `data/processed/`, so CI and GitHub Pages can build the site without
  the 1.7 GB raw download (see ADR 0002).
- Render the map with MapLibre GL:
  - Grid layers (cells with MAT of 29 degrees C or more at each warming level,
    and population density) as full-resolution 1/12 degree PNG images,
    reprojected to Web Mercator in preprocessing. A test on 2026-11-13 gave
    50 to 85 KB per exposure layer and about 310 KB for population, so all
    eight warming levels fit in well under 1 MB and no coarsening is needed.
  - Countries as a simplified vector layer for hover and click, carrying the
    per-country numbers. Cell-level hover is not needed for this audience.
  - No third-party basemap: the land and country layers are enough, and this
    avoids API keys and tile-service dependencies.

## Consequences

- No server to run or pay for; the site is fast and easy to share as a link.
- Nothing can be recomputed in the browser. New thresholds or regions need a
  new preprocessing run and a commit of the outputs.
- Contributors need Node.js for the site and Python with `uv` for
  preprocessing.
- CI gets a site build job once the Framework project exists.
