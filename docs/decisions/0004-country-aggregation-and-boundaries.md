# Country aggregation method and boundaries

## Status

Accepted

## Context

The country ranking needs people exposed to unprecedented heat (MAT of 29
degrees C or more) per country at every warming level, not only the 1.5 and
2.7 degrees C levels the paper publishes (Fig. 5). The authors' code deposit
only plots Fig. 5 from a finished spreadsheet, so the aggregation method had to
be reconstructed. Tests on 2026-11-13 showed that the following reproduces the
paper's Fig. 5 data exactly:

- Average MAT across the climate models first (ensemble mean), then apply the
  threshold (MAT greater than 29 degrees C). Averaging per-model exposure
  instead gives 2,113 M at 2.7 degrees C, not the paper's 1,997 M.
- Assign each 1/12 degree grid cell to the country polygon that contains the
  cell centre. Cells whose centre falls in no polygon (mostly coastal) are
  dropped, as in the paper (55 M exposed people at 2.7 degrees C).
- Use the World Borders Dataset 0.3 (2008). Global totals then match to the
  million (1,997 M and 419 M at 2.7 and 1.5 degrees C for 9.5 billion people,
  2,495 M at 2.7 degrees C for 11.1 billion), every country's population
  matches (r = 1.0000, 0.0 percent total difference), and exposed land area
  matches to within 0.3 percent.
- Land fraction is exposed land area divided by the country polygon's area,
  not by the summed area of its grid cells.

World Borders 0.3 predates South Sudan, so the paper's "Sudan" includes South
Sudan, and it is licensed CC BY-SA 3.0, so files derived from it must be
share-alike. Its original host (thematicmapping.org) no longer responds; a copy
is on a NOAA file server. Natural Earth admin 0 (10m) has current borders and
is public domain; with it the totals are within 0.2 percent and countries
differ by 1.5 percent overall, mainly Sudan (64 M vs. 79.5 M at 2.7 degrees C).

## Decision

- Publish country results computed with Natural Earth admin 0 (10m) borders,
  using the paper's method above.
- Keep a validation step in preprocessing that recomputes the 1.5 and 2.7
  degrees C country results with World Borders 0.3 and checks them against the
  paper's Fig. 5 spreadsheet. World Borders is used only for this check and is
  never published.
- The methods page states that country totals differ slightly from the paper
  because of updated borders, and names Sudan and South Sudan explicitly.

## Consequences

- Country results reflect current borders and can be released without a
  share-alike requirement.
- A reader comparing the site with the paper's Fig. 5 will see small
  differences, mostly Sudan; the methods note explains why.
- The validation step proves the method reproduces the paper, so differences
  can be attributed to borders alone.
- Global (non-country) totals are unaffected by the boundary choice.
