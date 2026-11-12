#!/usr/bin/env bash
# Downloads the raw data and supplementary files for Lenton et al. (2023).
# Run from the repo root.
set -euo pipefail
mkdir -p data/raw data/supplementary

# Authors' data deposit (CC BY 4.0), ~1.7 GB
curl -L --retry 5 -C - -o data/raw/Data.zip https://ndownloader.figshare.com/files/40207693
unzip -tq data/raw/Data.zip
unzip -oq data/raw/Data.zip -d data/raw/

# Nature Sustainability supplementary files
base="https://static-content.springer.com/esm/art%3A10.1038%2Fs41893-023-01132-6/MediaObjects"
for f in MOESM1_ESM.pdf MOESM2_ESM.pdf MOESM3_ESM.xlsx; do
  curl -sL -A "Mozilla/5.0" -o "data/supplementary/41893_2023_1132_$f" "$base/41893_2023_1132_$f"
done
