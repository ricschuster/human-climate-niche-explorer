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

# Country boundaries (see docs/decisions/0004-country-aggregation-and-boundaries.md)
# Natural Earth admin 0, 10m (public domain): used for published country results.
mkdir -p data/raw/boundaries/naturalearth data/raw/boundaries/worldborders
curl -L -A "Mozilla/5.0" -o data/raw/boundaries/naturalearth/ne_10m_admin_0_countries.zip \
  https://naciscdn.org/naturalearth/10m/cultural/ne_10m_admin_0_countries.zip
unzip -oq data/raw/boundaries/naturalearth/ne_10m_admin_0_countries.zip -d data/raw/boundaries/naturalearth/

# World Borders 0.3 (CC BY-SA 3.0): used only to validate against the paper, never published.
# The original host (thematicmapping.org) is offline; this is a NOAA copy.
wb="https://www.star.nesdis.noaa.gov/data/smcd1/vhp/GIS/TM_World_Borders"
for ext in dbf prj shp shx; do
  curl -L -o "data/raw/boundaries/worldborders/TM_WORLD_BORDERS-0.3.$ext" "$wb/TM_WORLD_BORDERS-0.3.$ext"
done
