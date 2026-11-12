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

Setup. The repo structure, source paper, supplementary data and authors' code
are in place, and the raw data deposit is downloadable with
`scripts/download_data.sh`. Next: inspect the `.mat` files, decide which views
to build, and choose the visualization stack (record it as an ADR). Open GitHub
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

Not chosen yet. Data processing will read the authors' MATLAB `.mat` files
(Python with scipy/h5py works, so MATLAB is not required). Record the
visualization stack choice as an ADR in `docs/decisions/`.

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
- Other commands: TBD once the stack is chosen; `CONTRIBUTING.md` Setup
  should match.

## Repo structure

- `paper/`: the article PDF.
- `data/raw/` (ignored), `data/supplementary/`, `data/processed/`.
- `reference/authors_code/`: authors' MATLAB / Python / R code, unmodified.
- `scripts/`: download and processing scripts.
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
