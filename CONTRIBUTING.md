# Contributing

Feedback, bug reports, and ideas are welcome through GitHub issues.

The workflow is:

1. Branch from `main` (one short-lived branch per change).
2. Keep changes small and focused.
3. Run the project checks locally before pushing (format, lint, tests, build).
   See the Setup section below for the exact commands once they are defined.
4. Open a pull request into `main`. CI must pass before merge.

## Setup

Prerequisites: `bash`, `curl`, `unzip`, [uv](https://docs.astral.sh/uv/)
for the Python preprocessing, Node.js 20 or later for the site.

```bash
./scripts/download_data.sh   # fetches about 1.7 GB of raw data into data/raw/
./scripts/build_all.sh       # rebuilds data/processed/ and validates it against the paper
uvx ruff check scripts && uvx ruff format --check scripts   # lint the scripts
```

You only need the raw data to change `data/processed/`; the site builds from
the committed processed files. See `scripts/README.md` for the pipeline and
`CLAUDE.md` for project rules, including how raw and processed data are
handled.

## Conventions

- Conventional Commits (for example `feat: ...`, `fix: ...`, `chore: ...`,
  `docs: ...`).
- No em dashes in code, comments, docs, commit messages, or user-facing text.
- See `CLAUDE.md` for the full working rules and `docs/` for design notes and
  decision records.
