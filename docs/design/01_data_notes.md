# 01 Data notes

What the preprocessing found when reproducing the paper from the authors'
data deposit, and the choices made where the paper, its data and its code
disagree. `scripts/validate.py` checks each point that can be checked.

## What is recomputed and what is read

- Hot exposure (MAT above 29 C) is recomputed from the grid in
  `displacement_data.mat` for every SSP, year, warming level and fixed
  population. It reproduces the paper's per-model numbers (Fig. 3a points in
  `mat29.mat`) to 5 significant digits.
- People left outside the niche (temperature only, and temperature plus
  demography) are read from the authors' per-model results in
  `nichedisplacement/1D/`. Recomputing them would mean refitting a
  double-Gaussian niche per climate model in MATLAB's curve-fitting toolbox;
  the published results already cover every SSP, year and warming level the
  site needs.
- Niche curves are recomputed with the authors' running-mean method
  (`Fig1_Extend157_MAT_Niche.m`).
- Country exposure is recomputed with the reconstructed method in ADR 0004 and
  matches the Fig. 5 spreadsheet country by country.

## Two ways of counting hot exposure

The global numbers (Figs. 2 and 3, the headline) average per-model exposure:
count people above 29 C under each climate model, then take the mean and
spread. The country numbers (Fig. 5) and the maps (Fig. 4) first average MAT
across models and then apply the threshold. The paper does both, so the site
does too, but they do not add up: at 2.7 C in a world of 9.5 billion the
global figure is 2.1 billion (22%), while the countries sum to 1,994 million
(1,997 million in the paper). The methods page should say so.

## Discrepancies with the paper

- **11.1 billion world, hot exposure percent.** The authors' code
  (`Fig3a_Extend8_Exposed_MAT_Felt.m`) divides the 11.1 billion counts by the
  9.5 billion total, which is why Fig. 3a gives 17.5 % per C for 11.1 billion.
  With the 11.1 billion total the slope is 14.8 % per C. The processed files
  use the correct denominator; the validation reproduces 17.5 with the
  authors' one. Head counts are unaffected. The MVP uses 9.5 billion only.
- **Rounding in the text.** Two quoted percentages are a little off from the
  data at the paper's own precision: 3.6 C hot exposure is printed as 34% (the
  model mean is 34.7%; the 3.3 billion and the sd match), and the 2030 SSP2
  outside-niche figure (temperature plus demography) is printed as 25% (the
  mean is 24.46%). The site shows the data's values.
- **People from percent.** The paper converts percent to people with a
  nominal 9.5 billion; the 2070 SSP2 grid totals 9.46 billion. So 29% at 2.7 C
  is 2.75 billion here and "2.8 billion" in the paper.
- **2010 outside the niche.** The paper's "624 plus or minus 70 million" is
  the temperature-only figure (9%), not the combined one (10%).
- **Niche curve position.** The authors plot each 2 C window at its lower
  edge in Fig. 1 and at its lower edge plus 0.5 C in Extended Data Fig. 1. The
  processed file gives the window centre, which is the honest position.
- **Reference niche scale.** Extended Data Fig. 1's reference curve
  (`Extend_Fig1_newref.mat`) came from an earlier study's pipeline. Its shape
  matches ours (correlation above 0.999) but its scale differs by up to 9%
  for two of the three climate datasets. Only shapes are compared on the site.
- **Hot threshold.** The paper writes "29 C or more"; the code uses strictly
  more than 29 C. With continuous temperatures this makes no difference.

## Country method details

See `docs/decisions/0004-country-aggregation-and-boundaries.md`. In short:
people by cell centre in polygon; land area by exact cell-polygon coverage on
the WGS84 ellipsoid; land fraction over the polygon's equal-area area, capped
at 100%. With World Borders 0.3 every country's exposed population is within
0.01 million and land fraction within 0.2 points of the paper. With Natural
Earth (published), cells outside every polygon hold 172 million of the 9.5
billion people.

## Map layers

Fig. 4 uses 12 population classes; the site uses 7 of the same breaks (0-10,
11-100, 101-1,000, and so on up to over 1,000,000 per cell) so a single-hue
ramp stays readable. Antarctica has no data in the grid and is not drawn.
