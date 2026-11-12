# 00 Project Brief

## What this is

Human Climate Niche Explorer is an interactive visualization of the results in
Lenton, Xu et al. (2023), "Quantifying the human cost of global warming"
(*Nature Sustainability* 6, 1237-1247). It turns the paper's static figures
into views people can explore by warming level, scenario, year and country.

It is a briefing and exploration tool, not a new analysis. The goal is for a
reader to see, for a given level of global warming, how many people (and which
places) end up outside the historical human climate niche, and how much
stronger climate policy would change that.

## Who it is for

- Primary: policy audiences and Nature Conservancy of Canada (NCC) staff who
  need to understand and quote the findings accurately.
- Secondary: anyone else who finds the published site.

Assumptions: readers are comfortable with charts and maps but are not climate
modellers. Numbers must be easy to quote and always shown with the uncertainty
range the paper gives (5th to 95th percentile across climate models, or mean
plus or minus one standard deviation where the paper uses that).

## The core idea (one screen)

A single global warming slider (1.5 to 4.4 degrees C, the levels used in the
paper) drives everything on the page. As the reader moves it, the map shows
where mean annual temperature (MAT) reaches 29 degrees C or more, a headline
counter shows how many people are exposed to that unprecedented heat, the niche
curve shifts to hotter temperatures, and a country ranking updates. Fixed
markers on the slider label the policy cases from the paper: 1.5 (Paris),
1.8 (all announced targets), 2.1 (binding long-term targets), 2.4 (2030 NDCs
only), 2.7 (current policies), and 3.6 and 4.4 (worst cases).

## What the data supports

Checked against the raw data on 2026-11-12:

- `displacement_data.mat` holds a 1/12 degree (about 10 km) land grid of
  2,287,025 cells with per-model MAT and mean annual precipitation for every
  SSP and 20-year period, matching population grids, the 1960-1990 and
  2000-2020 baselines, and 1980 and 2010 population.
- Recomputing hot exposure from the grid reproduces the paper: SSP2-4.5 in
  2090 gives 23.2 plus or minus 9.1 percent (paper: 23 plus or minus 9), and
  the 2010 population under 2000-2020 climate gives 0.9 percent (paper: 0.9).
- The figure-level `.mat` files hold the niche curves, per-model exposure for
  each SSP and year, and the warming vs. exposure series for fixed populations.
- The country-level spreadsheets cover heat exposure at 1.5 and 2.7 degrees C
  and the emissions and poverty data behind Fig. 6.

## MVP scope

Population is held at the paper's reference world of 9.5 billion (SSP2, 2070)
in every view driven by the warming slider, as in Figs. 3 to 5.

1. Headline panel: people and percent exposed to unprecedented heat (MAT of
   29 degrees C or more) and left outside the niche at the selected warming
   level, with ranges, compared with current policies (2.7 degrees C).
2. Map: cells with MAT of 29 degrees C or more at the selected warming level,
   over population density (Fig. 4, generalized to all eight warming levels).
3. Niche curve: population density vs. MAT at the selected warming level
   against the 1980 reference (Fig. 1c).
4. Exposure vs. warming chart with the selected level highlighted and the
   per-model spread (Fig. 3).
5. Country ranking of people exposed at the selected warming level, with the
   1.5 degree C value alongside (Fig. 5).
6. Methods and sources page: what the niche is, what is and is not counted,
   and full attribution.

## Later layers

- Scenario explorer: exposure over time for each SSP with model spread
  (Fig. 2), including demographic change.
- Who emits, who is exposed: per capita emissions vs. exposure, coloured by
  poverty rate (Fig. 6), and the "about 460 tC per person exposed" relation
  as a small calculator.
- Regional views (for example Canada) computed from the grid with the paper's
  method. These would be our derived numbers, not the paper's, and must be
  labelled as such.

## Explicit non-goals (for now)

- Re-running the global analysis from raw CMIP6 and SSP population inputs.
- New projections, or numbers the paper's method and data cannot support.
- Wet-bulb temperature views: the CMIP6 wet-bulb data in `extremetemp.mat` is
  stored as a MATLAB table object that cannot be read outside MATLAB.

## Design principles

1. Faithful to the paper: every number traces back to the paper or is
   recomputed from its data with its method, and derived numbers say so.
2. Always show uncertainty next to a central estimate.
3. Quotable: every headline number has a short plain-language sentence a
   reader could lift into a briefing.
4. Credit the source clearly (CC BY 4.0) on every page.

## Open questions

- Map rendering: precomputed raster images per warming level vs. a coarser
  vector grid that supports hover. See ADR 0003.
- Country boundaries: the paper used the World Borders Dataset; Natural Earth
  may be easier to source. Results must match the paper's Fig. 5 data at 1.5
  and 2.7 degrees C whichever is used.
- Whether NCC branding should appear, or the site stays neutral.
