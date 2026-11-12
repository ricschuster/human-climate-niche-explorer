# 00 Project Brief

## What this is

Human Climate Niche Explorer is an interactive visualization of the results in
Lenton, Xu et al. (2023), "Quantifying the human cost of global warming"
(*Nature Sustainability* 6, 1237-1247). It turns the paper's static figures
into views people can explore by scenario, year, warming level and country.

It is a communication and exploration tool, not a new analysis. The goal is for
a reader to understand, for a given warming path, how many people (and which
places) end up outside the historical human climate niche.

## Who it is for

- To be decided. Candidates: conservation and climate staff, policy audiences,
  and the general public.

## The core idea (one screen)

To be decided once the data has been inspected. Candidate views, all backed by
the authors' data deposit:

1. The niche curve: population density vs. mean annual temperature, with the
   1980 reference against future scenarios and warming levels (Fig. 1).
2. Exposure over time for each SSP: unprecedented heat, temperature change
   only, and temperature plus demographic change (Fig. 2).
3. Exposure vs. global warming for fixed populations of 6.9, 9.5 and 11.1
   billion (Fig. 3).
4. Maps of where MAT reaches 29 degrees C or more at 1.5 vs. 2.7 degrees C
   (Fig. 4), if the gridded data supports it.
5. Country-level exposure at 1.5 vs. 2.7 degrees C (Fig. 5).
6. Per capita emissions vs. exposure and poverty by country (Fig. 6).

## MVP scope

To be decided.

## Explicit non-goals (for now)

- Re-running the global analysis from raw CMIP6 and SSP population inputs.
- New projections or numbers beyond what the paper and data deposit support.

## Design principles

1. Faithful to the paper: every number shown traces back to the paper or its
   data deposit, with uncertainty ranges where the paper gives them.
2. Credit the source clearly (CC BY 4.0).

## Open questions

- Primary audience.
- Which views make the MVP.
- Stack: static site (for example Observable Plot, D3, or Plotly), a Shiny
  app, or something else; hosting (GitHub Pages?).
- What `displacement_data.mat` (about 1.75 GB) contains and how much of it can
  be reduced to web-sized files.
