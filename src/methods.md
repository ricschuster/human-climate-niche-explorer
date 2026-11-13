---
title: Methods and sources
---

# Methods and sources

<p class="prose">This site presents the results of one study: Lenton, T. M., Xu, C., Abrams, J. F. et al. (2023). <a href="https://doi.org/10.1038/s41893-023-01132-6">Quantifying the human cost of global warming</a>. <i>Nature Sustainability</i> 6, 1237-1247. It does not make new projections. Every number is either published in the paper or recomputed from the authors' own data with the authors' method, and recomputed numbers that the paper does not report are labelled <span class="badge">Derived</span>.</p>

## The human climate niche

<p class="prose">Historically, human population density has followed a stable distribution with respect to mean annual temperature (MAT): a main peak around 13 °C and a second peak around 27 °C, in monsoon climates mainly in South Asia. The paper calls this the human climate niche. Its reference version combines the 1980 population with the 1960-1990 climate, when global warming was about 0.3 °C.</p>

## What is counted

- **Exposed to unprecedented heat.** People living where the mean annual temperature is 29 °C or more. Very few people have ever lived in such places; they average over 75 days a year with a maximum temperature above 40 °C. This is the paper's simplest and most conservative measure, and the one the headline, map and country ranking use.
- **Left outside the niche by temperature change.** The paper maps the reference niche onto the present and future climate and measures how much of the population distribution the niche implies has shifted away from where it is under the reference climate. That share of the population is counted as left outside the niche.
- **Left outside the niche by temperature and demographic change.** As above, plus the effect of population growing fastest in already hot places. The paper treats this as an upper estimate.

<p class="prose">The outside-the-niche numbers come straight from the authors' published results for each climate model. Unprecedented heat, the niche curves and the country numbers are recomputed here from the authors' 1/12 degree (about 10 km) grid. The recomputed values match the numbers in the paper.</p>

## Warming levels

<p class="prose">Each warming level is the projected climate of one SSP scenario over one 20-year period, as in the paper. Population is held fixed at 9.5 billion people (the SSP2 projection for 2070), so differences between levels come from climate alone.</p>

```js
const levels = FileAttachment("data/warming_levels.csv").csv({typed: true});
```

```js
Inputs.table(levels, {
  columns: ["warming", "policy", "ssp", "period", "n_models"],
  header: {warming: "Warming (°C)", policy: "Policy case in the paper", ssp: "Scenario", period: "Climate period", n_models: "Climate models"},
  format: {warming: (d) => d.toFixed(1)},
  rows: 10,
  select: false,
  layout: "auto"
})
```

<p class="prose">1.0 °C is the observed climate of 2000-2020. The policy cases follow the paper: current policies lead to about 2.7 °C; meeting 2030 nationally determined contributions (NDCs) only, about 2.4 °C; binding long-term targets, about 2.1 °C; all announced targets, about 1.8 °C; and 1.5 °C is the Paris Agreement goal. 3.6 and 4.4 °C are worst cases.</p>

## Uncertainty

<p class="prose">Each number is computed once per climate model (5 to 8 models per level). The site shows the mean across models with the 5th to 95th percentile range, as in the paper's figures. The quotable sentence uses the mean plus or minus one standard deviation, as in the paper's text. The lines in the exposure charts are the paper's linear fits across all 65 model runs, with 95% confidence bands.</p>

## Countries

<p class="prose">The paper ranks countries at 1.5 and 2.7 °C (its Fig. 5). Its method, reconstructed here, reproduces those numbers country by country. It first averages temperature across the climate models, then counts the people in grid cells at or above 29 °C whose centre lies in each country. Exposed land is the area of the country covered by those cells.</p>

- **Borders.** The paper used a 2008 boundary dataset in which Sudan includes South Sudan. This site uses current borders from Natural Earth, so its country numbers differ slightly from the paper's, mainly for Sudan (64 million exposed at 2.7 °C here, against 79.5 million in the paper).
- **Other warming levels.** Country numbers at levels other than 1.5 and 2.7 °C are not in the paper. They are computed with the same data and method and labelled derived.
- **Countries vs. world totals.** Averaging temperature across models before counting gives fewer exposed people than counting per model and then averaging, which is how the global figures are made. At 2.7 °C the countries add up to about 2.0 billion people, while the global figure is 2.1 billion. Both follow the paper. Coastal cells whose centre falls in no country are left out of the country numbers.

## The map

<p class="prose">The orange areas have a mean annual temperature, averaged across climate models, of 29 °C or more at the selected warming level. Underneath is the population of a world of 9.5 billion people per grid cell of about 100 km², in classes taken from the paper's Fig. 4. The map uses the Web Mercator projection, which enlarges areas towards the poles. Antarctica is not in the data.</p>

## Not covered

- Wet-bulb temperature and the number of very hot days are discussed in the paper but not shown here.
- Emissions and poverty (the paper's Fig. 6) and the scenario-by-year view (Fig. 2) are planned for a later version.
- The niche says where people have lived, not where they can live. Exposure does not mean people will move or die; the paper discusses the many harms and adaptations involved.

## Data downloads

<p class="prose">The processed data behind every view, produced by the scripts in the <a href="https://github.com/ricschuster/human-climate-niche-explorer">project repository</a>:</p>

- <a href=${FileAttachment("data/by_warming_summary.csv").href} download>Global exposure by warming level</a> (CSV)
- <a href=${FileAttachment("data/by_warming_models.csv").href} download>Global exposure for each climate model run</a> (CSV)
- <a href=${FileAttachment("data/by_ssp_year_summary.csv").href} download>Global exposure by scenario and year</a> (CSV)
- <a href=${FileAttachment("data/countries_by_warming.csv").href} download>Countries by warming level</a> (CSV)
- <a href=${FileAttachment("data/niche_curves.csv").href} download>Niche curves</a> (CSV)

<p class="prose">A data dictionary and notes on the small differences from the paper (for example, how the paper rounds some figures) are in the repository's <code>data/processed/README.md</code> and <code>docs/design/01_data_notes.md</code>.</p>

## Sources and licence

- Paper, supplementary data and the authors' code: Lenton, Xu et al. (2023), <a href="https://doi.org/10.1038/s41893-023-01132-6">doi:10.1038/s41893-023-01132-6</a>, and the data deposit at <a href="https://doi.org/10.6084/m9.figshare.22650361">doi:10.6084/m9.figshare.22650361</a>. Both CC BY 4.0.
- Country borders: <a href="https://www.naturalearthdata.com/">Natural Earth</a>, public domain.
- This site is an independent visualization of the published study. It is not produced or endorsed by the paper's authors.
