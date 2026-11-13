# CLAUDE.md

Working rules and durable context for this project. This file is loaded into
context automatically, so keep it to direction and rules, not a task list.

## Project name

Human Climate Niche Explorer

## Project purpose

An interactive visualization of the results in Lenton, Xu et al. (2023),
"Quantifying the human cost of global warming", *Nature Sustainability* 6,
1237-1247 (<https://doi.org/10.1038/s41893-023-01132-6>). The paper defines the
"human climate niche" (the historically stable distribution of human population
density with respect to mean annual temperature, MAT) and estimates how many
people are left outside it under four SSP scenarios (SSP1-2.6, SSP2-4.5,
SSP3-7.0, SSP5-8.5) and fixed warming levels from 1.5 to 4.4 degrees C. The goal
is to let people explore those scenarios, years, warming levels and countries
themselves rather than read static figures. See
`docs/design/00_project_brief.md` for the full brief.

## Project status

Build. Audience (policy and NCC staff) and stack (static site) are decided;
the MVP is defined in `docs/design/00_project_brief.md`. The preprocessing
scripts in `scripts/` produce `data/processed/` and `scripts/validate.py`
checks it against the paper (see `docs/design/01_data_notes.md` for known
differences). The Observable Framework site (`src/`) implements the MVP views;
see `docs/design/02_site.md`. Next: deployment to GitHub Pages. Open GitHub
issues are the live task tracker.

## Scope

In scope: faithfully presenting the paper's published results (niche curves,
exposure over time per SSP, exposure vs. warming, country-level heat exposure,
emissions and poverty relationships, and maps where the data allows).

Not in scope: re-running the global analysis from raw CMIP6 and SSP population
inputs, producing new projections, or presenting numbers the paper and its data
deposit do not support. Do not expand scope without a design note in
`docs/design/` or an ADR in `docs/decisions/`.

## Stack

- Site: Observable Framework, deployed to GitHub Pages, maps with MapLibre GL
  (`docs/decisions/0003-static-site-with-observable-framework.md`).
- Preprocessing: Python scripts in `scripts/`, run with `uv` and inline
  dependencies (scipy reads the authors' MATLAB v5 `.mat` files directly).
- Nothing is recomputed in the browser: the site reads only `data/processed/`.

## Data rules

- Raw data lives in `data/raw/` and is never committed (see
  `docs/decisions/0002-keep-raw-data-out-of-git.md`). `displacement_data.mat`
  alone is about 1.75 GB.
- `data/processed/` holds small derived files the visualization reads. Every
  processed file must be reproducible from a script in `scripts/`.
- `reference/authors_code/` is the authors' original code, kept unmodified as a
  reference for how each figure was computed.
- All source material is CC BY 4.0: keep the attribution in `README.md`.

## Commands

- Get raw data: `./scripts/download_data.sh` (downloads about 1.7 GB; slow).
- Rebuild `data/processed/` and validate against the paper:
  `./scripts/build_all.sh` (first run about 10 minutes; caches in
  `~/.cache/human-climate-niche-explorer/`). One step:
  `uv run scripts/<step>.py`. Validation alone: `uv run scripts/validate.py`.
- Lint Python: `uvx ruff check scripts && uvx ruff format --check scripts`.
- Site: `npm ci`, then `npm run dev` (preview) or `npm run build` (to
  `dist/`). Both copy `data/processed/` into `src/data/` first. See
  `docs/design/02_site.md`.
- `CONTRIBUTING.md` Setup should match these commands.

## Repo structure

- `paper/`: the article PDF.
- `data/raw/` (ignored), `data/supplementary/`, `data/processed/`.
- `reference/authors_code/`: authors' MATLAB / Python / R code, unmodified.
- `scripts/`: download and processing scripts.
- `src/`, `observablehq.config.js`, `package.json`: the site.
- `docs/`: design notes, ADRs, handoffs.

## Working rules

- Branch from `main`; one short-lived branch per change. Open a pull request
  into `main`; CI must pass before merge.
- Conventional Commits (for example `feat: ...`, `fix: ...`, `chore: ...`,
  `docs: ...`).
- No em dashes in code, comments, docs, commit messages, or user-facing text.
- Significant technical or design decisions get an ADR in `docs/decisions/`.
- Design notes live in `docs/design/`; session handoffs in `docs/handoffs/`.
- Keep changes small and focused; update docs when behaviour or design changes.
