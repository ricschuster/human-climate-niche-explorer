# Contributing

Feedback, bug reports, and ideas are welcome through GitHub issues.

The workflow is:

1. Branch from `main` (one short-lived branch per change).
2. Keep changes small and focused.
3. Run the project checks locally before pushing (format, lint, tests, build).
   See the Setup section below for the exact commands once they are defined.
4. Open a pull request into `main`. CI must pass before merge.

## Setup

Prerequisites: `bash`, `curl`, `unzip`.

```bash
./scripts/download_data.sh   # fetches about 1.7 GB of raw data into data/raw/
```

Build, run and check commands will be added once the visualization stack is
chosen. See `CLAUDE.md` for project rules, including how raw and processed data
are handled.

## Conventions

- Conventional Commits (for example `feat: ...`, `fix: ...`, `chore: ...`,
  `docs: ...`).
- No em dashes in code, comments, docs, commit messages, or user-facing text.
- See `CLAUDE.md` for the full working rules and `docs/` for design notes and
  decision records.
