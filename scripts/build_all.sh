#!/usr/bin/env bash
# Rebuilds data/processed/ from data/raw/ and checks the result against the paper.
# Run from anywhere; needs uv and the raw data (./scripts/download_data.sh).
# First run: about 10 minutes (caches the grid and the country lookups);
# later runs: under a minute plus about 2 minutes for validation.
set -euo pipefail
cd "$(dirname "$0")/.."
for step in build_global build_niche_curves build_countries build_map_layers; do
  echo "== $step"
  uv run -q "scripts/$step.py"
done
echo "== validate"
uv run -q scripts/validate.py
