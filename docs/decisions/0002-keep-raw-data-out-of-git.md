# Keep raw data out of git

## Status

Accepted

## Context

The authors' data deposit (figshare, 10.6084/m9.figshare.22650361) is about
1.7 GB zipped. One file, `displacement_data.mat`, is about 1.75 GB on its own,
well over GitHub's 100 MB per-file limit. The deposit is public, versioned and
has a stable DOI, so the repo does not need to hold a copy.

## Decision

- `data/raw/` is git-ignored, along with all `.zip` and `.mat` files.
- `scripts/download_data.sh` fetches the deposit and the Nature supplementary
  files, so anyone can rebuild `data/raw/`.
- Small files are committed: the supplementary files in `data/supplementary/`
  and the derived files the visualization reads in `data/processed/`.
- Each processed file must be reproducible from a script in `scripts/`.

## Consequences

- The repo stays small and clones quickly.
- Contributors who want to regenerate processed data must download about
  1.7 GB first.
- If the figshare deposit ever disappears, the processed files still let the
  visualization run, but they could not be regenerated without a copy of the
  raw data.
