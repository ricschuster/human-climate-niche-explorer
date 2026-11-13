# 02 Site

How the Observable Framework site is put together. The brief
(`00_project_brief.md`) says what it shows; ADR 0003 says why this stack.

## Layout of the code

- `observablehq.config.js`: pages, theme, footer.
- `src/index.md`: the explorer page. One warming slider drives everything.
- `src/methods.md`: methods, caveats, downloads, sources.
- `src/components/`: `slider.js` (the warming control), `map.js`
  (MapLibre), `charts.js` (Observable Plot), `format.js` (number wording).
- `src/style.css`: theme imports and the colour tokens.
- `scripts/copy_site_data.mjs`: copies `data/processed/` to `src/data/`
  (git-ignored) before every `npm run dev` or `npm run build`, so
  `data/processed/` stays the single source of truth.

Commands: `npm ci`, then `npm run dev` (local preview with live reload) or
`npm run build` (static site in `dist/`). The build needs only the committed
processed data, not the raw deposit.

## Decisions

- **One control.** The warming slider sits in a sticky row above every view.
  Its track is proportional to temperature but the value snaps to the paper's
  eight levels (1.5 to 4.4 C); arrow keys step between levels. Only the two
  cases the paper contrasts (1.5 C Paris goal, 2.7 C current policies) are
  labelled under the track; the readout names the selected level's policy
  case, SSP and period.
- **Population fixed at 9.5 billion** in every slider-driven view, as in the
  paper's Figs. 3 to 5.
- **Headline.** Mean across climate models with the 5th to 95th percentile
  range; the quotable sentence uses mean plus or minus sd, the paper's text
  convention, and a copy button.
- **Map.** No basemap. Pre-coloured palette PNGs, already in Web Mercator,
  split into western and eastern halves to stay under the 4096 pixel texture
  limit of some mobile GPUs. Population has a light and a dark variant; the
  hot layer is drawn at 80% opacity so density shows through. Countries are a
  GeoJSON layer used only for outlines and the hover readout.
- **Charts.** Observable Plot. Fig. 3 is shown as three panels (hot exposure,
  outside the niche by temperature, outside the niche by temperature and
  demography) rather than a metric switch, so there is still only one control.
- **Derived numbers.** Country results at levels other than 1.5 and 2.7 C carry
  a "Derived" badge and a sentence saying they are computed, not published.

## Colour

Roles are CSS variables in `style.css`, with separate dark-mode steps:

| Role | Light | Dark | Used for |
| --- | --- | --- | --- |
| `--hot` | `#eb6834` | `#d95926` | selected warming level, unprecedented heat |
| `--reference` | `#2a78d6` | `#3987e5` | reference niche, 1.5 C comparison ticks |
| `--context` | `#898781` | `#898781` | other model runs, fit lines (de-emphasis only) |

The orange and blue pair passes the dataviz palette validator (lightness band,
chroma, colour-vision-deficiency separation, contrast) in both modes. The grey
fails the chroma floor by design and never identifies a series. The map's
population ramp is single-hue blue (steps 100 to 700), reversed for dark mode
so that low density recedes towards the page in both themes.

## Deployment

`.github/workflows/deploy-pages.yml` builds the site from the committed
`data/processed/` and publishes `dist/` with `actions/upload-pages-artifact`
and `actions/deploy-pages`. The site lives under the repository path
(`https://ricschuster.github.io/human-climate-niche-explorer/`); Framework
writes relative links, so no base path setting is needed.

The workflow runs on every push to `main` (so every merged PR redeploys) and
can be started by hand with `gh workflow run deploy-pages.yml`. Pages is
enabled with GitHub Actions as the source. The site went live on 2026-11-13;
the audience review of the wording happens on the live site.

## Not yet done

- Review of the wording by the audience (policy or NCC staff).
- The scenario-by-year view (Fig. 2) and emissions and poverty (Fig. 6), listed
  as later layers in the brief.
- A favicon and social preview image.
