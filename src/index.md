---
title: Explore
---

<link rel="stylesheet" href="npm:maplibre-gl@5.24.0/dist/maplibre-gl.css">

```js
import {warmingSlider} from "./components/slider.js";
import {createMap} from "./components/map.js";
import {exposureVsWarming, nicheCurve, countryBars} from "./components/charts.js";
import {people, peopleParts, pct, millions, degrees} from "./components/format.js";
```

```js
const levels = FileAttachment("data/warming_levels.csv").csv({typed: true});
const summary = FileAttachment("data/by_warming_summary.csv").csv({typed: true});
const models = FileAttachment("data/by_warming_models.csv").csv({typed: true});
const fits = FileAttachment("data/by_warming_fit_curve.csv").csv({typed: true});
const curves = FileAttachment("data/niche_curves.csv").csv({typed: true});
const countryRows = FileAttachment("data/countries_by_warming.csv").csv({typed: true});
const countries = FileAttachment("data/countries.geojson").json();
const layers = FileAttachment("data/map/layers.json").json();
```

```js
// Every file the map can show, listed literally so the build bundles them.
const hotFiles = {
  "1.5": [FileAttachment("data/map/hot_1.5_w.png"), FileAttachment("data/map/hot_1.5_e.png")],
  "1.8": [FileAttachment("data/map/hot_1.8_w.png"), FileAttachment("data/map/hot_1.8_e.png")],
  "2.0": [FileAttachment("data/map/hot_2.0_w.png"), FileAttachment("data/map/hot_2.0_e.png")],
  "2.1": [FileAttachment("data/map/hot_2.1_w.png"), FileAttachment("data/map/hot_2.1_e.png")],
  "2.4": [FileAttachment("data/map/hot_2.4_w.png"), FileAttachment("data/map/hot_2.4_e.png")],
  "2.7": [FileAttachment("data/map/hot_2.7_w.png"), FileAttachment("data/map/hot_2.7_e.png")],
  "3.6": [FileAttachment("data/map/hot_3.6_w.png"), FileAttachment("data/map/hot_3.6_e.png")],
  "4.4": [FileAttachment("data/map/hot_4.4_w.png"), FileAttachment("data/map/hot_4.4_e.png")]
};
const populationFiles = {
  light: [FileAttachment("data/map/population_light_w.png"), FileAttachment("data/map/population_light_e.png")],
  dark: [FileAttachment("data/map/population_dark_w.png"), FileAttachment("data/map/population_dark_e.png")]
};
async function urls([w, e]) {
  return {w: await w.url(), e: await e.url()};
}
```

```js
const futureLevels = levels.filter((d) => d.warming >= 1.5);
const warmingInput = warmingSlider(futureLevels, {value: 2.7});
const warming = Generators.input(warmingInput);
const isDark = Generators.dark();
```

# How many people would be left outside the human climate niche?

<p class="prose">Historically, people have lived mostly where the mean annual temperature is around 13 °C, with a second peak near 27 °C in monsoon climates: the <b>human climate niche</b>. Lenton, Xu and colleagues (2023) estimate how many people global warming would push outside it. Move the slider to see what each level of warming means, for a future world of 9.5 billion people.</p>

<div class="controls">${warmingInput}</div>

```js
const pick = (metric, w) => summary.find((d) => d.population === "9.5bn" && d.metric === metric && d.warming === w);
const level = futureLevels.find((d) => d.warming === warming);
const hot = pick("hot", warming);
const hot27 = pick("hot", 2.7);
const hot15 = pick("hot", 1.5);
const outT = pick("outside_temp", warming);
const outC = pick("outside_combined", warming);
const [heroNumber, heroUnit] = peopleParts(hot.people_mean);
const scenarioText = `${degrees(warming)}${level.policy ? ` (${level.policy.toLowerCase()})` : ""}`;
```

```js
function comparison() {
  if (warming === 2.7) return `Holding warming to 1.5 °C instead would cut this to ${people(hot15.people_mean)}, about ${Math.round(hot27.people_mean / hot15.people_mean)} times fewer.`;
  const diff = hot.people_mean - hot27.people_mean;
  return diff < 0
    ? `That is ${people(-diff)} fewer people than under current policies (2.7 °C, ${people(hot27.people_mean)}).`
    : `That is ${people(diff)} more people than under current policies (2.7 °C, ${people(hot27.people_mean)}).`;
}
const quote = `At ${degrees(warming)} of global warming, about ${hot.pct_mean.toFixed(0)} ± ${hot.pct_sd.toFixed(0)}% of a future world of 9.5 billion people (${(hot.people_mean / 1e9).toFixed(1)} ± ${(hot.people_sd / 1e9).toFixed(1)} billion) would be exposed to unprecedented heat, a mean annual temperature of 29 °C or more (Lenton et al. 2023, Nature Sustainability; mean ± s.d. across climate models).`;
const copyButton = html`<button type="button">Copy sentence</button>`;
copyButton.onclick = async () => {
  try {
    await navigator.clipboard.writeText(quote);
    copyButton.textContent = "Copied";
  } catch {
    copyButton.textContent = "Select the text to copy";
  }
  setTimeout(() => (copyButton.textContent = "Copy sentence"), 2000);
};
```

<div class="grid grid-cols-3">
  <div class="card grid-colspan-2">
    <div class="stat-label">Exposed to unprecedented heat at ${scenarioText}</div>
    <div class="hero">${heroNumber} <span class="hero-unit">${heroUnit} people</span></div>
    <div>${pct(hot.pct_mean)} of 9.5 billion, living where the mean annual temperature is 29 °C or more. Places this hot average over 75 days a year above 40 °C.</div>
    <div class="stat-range">Range across climate models: ${people(hot.people_p5)} to ${people(hot.people_p95)} (5th to 95th percentile).</div>
    <p>${comparison()}</p>
    <blockquote class="quote">${quote}</blockquote>
    <div class="quote-actions">${copyButton}</div>
  </div>
  <div class="card">
    <div class="stat-label">Left outside the niche by temperature change</div>
    <div class="stat-value">${pct(outT.pct_mean)} <span class="stat-range">· ${people(outT.people_mean)}</span></div>
    <div class="stat-range">${pct(outT.pct_p5)} to ${pct(outT.pct_p95)} across models</div>
    <hr>
    <div class="stat-label">Left outside the niche by temperature and demographic change</div>
    <div class="stat-value">${pct(outC.pct_mean)} <span class="stat-range">· ${people(outC.people_mean)}</span></div>
    <div class="stat-range">${pct(outC.pct_p5)} to ${pct(outC.pct_p95)} across models</div>
    <p class="caption">"Outside the niche" counts people living at temperatures where, historically, far fewer people have lived. Demographic change adds the effect of population growing fastest in already hot places. Unprecedented heat is the most extreme part of this. <a href="./methods">How these are counted</a>.</p>
  </div>
</div>

## Where unprecedented heat would be

```js
const mapContainer = html`<div class="map" role="img" aria-label="World map of places with mean annual temperature of 29 °C or more at the selected warming level, over population density"></div>`;
const popLegend = html`<div class="legend" aria-label="Legend">
  <span class="key"><span class="swatch" style="background: ${layers.hot.color}; opacity: 0.8"></span>Mean annual temperature 29 °C or more</span>
  <span class="key">People per ~100 km²:</span>
  ${layers.population.classes.map((c, i) => html`<span class="key"><span class="swatch" style="background: ${isDark ? c.color_dark : c.color_light}"></span>${i === 0 || i === layers.population.classes.length - 1 ? c.label : ""}</span>`)}
</div>`;
```

<div class="card">
  <h2>Places with a mean annual temperature of 29 °C or more at ${degrees(warming)}</h2>
  <div class="caption">Over population density in a world of 9.5 billion (SSP2, 2070). Hover a country for its numbers. Climate: mean of the climate models.</div>
  ${popLegend}
  ${mapContainer}
</div>

```js
// MapLibre needs a plain colour, so read the hex ink token from style.css.
const lineColor = () => getComputedStyle(document.documentElement).getPropertyValue("--ink-secondary").trim() || "#52514e";
const mapView = createMap(mapContainer, {
  layers,
  population: await urls(populationFiles.light),
  hot: await urls(hotFiles["2.7"]),
  countries,
  lineColor: lineColor()
});
invalidation.then(async () => (await mapView).map.remove());
```

```js
// Keep the map in step with the slider and the page theme.
mapView.setHot(await urls(hotFiles[warming.toFixed(1)]));
mapView.setLevel(
  warming,
  new Map(countryRows.filter((d) => d.warming === warming).map((d) => [d.id, d]))
);
```

```js
mapView.setPopulation(await urls(populationFiles[isDark ? "dark" : "light"]));
mapView.setLineColor(lineColor());
```

## How the niche shifts

<div class="grid grid-cols-2">
  <div class="card">
    <h2>Where people live, by mean annual temperature</h2>
    <div class="caption">Relative population density. The bands are the 5th to 95th percentile across climate models.</div>
    <div class="legend">
      <span class="key"><span class="line" style="background: var(--reference)"></span>Reference niche: 1980 population, 1960-1990 climate</span>
      <span class="key"><span class="line" style="background: var(--hot)"></span>${degrees(warming)}, 9.5 billion people</span>
    </div>
    ${resize((width) => nicheCurve({curves, level: warming, width}))}
  </div>
  <div class="card">
    <h2>Exposure rises steadily with warming</h2>
    <div class="caption">Each dot is one climate model run (65 in all); the line is the paper's linear fit with its 95% confidence band. Selected level in orange, with its mean.</div>
    ${resize((width) => exposureVsWarming({models: models.filter((d) => d.population === "9.5bn"), fit: fits.filter((d) => d.population === "9.5bn"), summary: summary.filter((d) => d.population === "9.5bn"), metric: "hot", level: warming, width, yMax: 60}))}
    <p class="caption">About ${fitText} per degree of warming, in a world of 9.5 billion.</p>
  </div>
</div>

```js
const fitRow = FileAttachment("data/by_warming_fit.csv").csv({typed: true});
```

```js
const fitText = (() => {
  const f = fitRow.find((d) => d.population === "9.5bn" && d.metric === "hot");
  return `${f.slope_pct_per_c.toFixed(1)} percentage points more people exposed (${people((f.slope_pct_per_c / 100) * 9.46e9)})`;
})();
```

<div class="grid grid-cols-2">
  <div class="card">
    <h2>Left outside the niche: temperature change</h2>
    ${resize((width) => exposureVsWarming({models: models.filter((d) => d.population === "9.5bn"), fit: fits.filter((d) => d.population === "9.5bn"), summary: summary.filter((d) => d.population === "9.5bn"), metric: "outside_temp", level: warming, width, height: 220, yMax: 70}))}
  </div>
  <div class="card">
    <h2>Left outside the niche: temperature and demographic change</h2>
    ${resize((width) => exposureVsWarming({models: models.filter((d) => d.population === "9.5bn"), fit: fits.filter((d) => d.population === "9.5bn"), summary: summary.filter((d) => d.population === "9.5bn"), metric: "outside_combined", level: warming, width, height: 220, yMax: 70}))}
  </div>
</div>

## Which countries

```js
const rowsAt = countryRows.filter((d) => d.warming === warming);
const rows15 = countryRows.filter((d) => d.warming === 1.5);
const derived = warming !== 1.5 && warming !== 2.7;
const countryTotal = rowsAt.reduce((s, d) => s + d["exposed_9.5bn"], 0);
```

<div class="card">
  <h2>People exposed to unprecedented heat at ${degrees(warming)}, top 15 countries ${derived ? html`<span class="badge">Derived</span>` : ""}</h2>
  <div class="caption">${derived
    ? "The paper reports countries at 1.5 and 2.7 °C only. These numbers are computed from the paper's data with its method."
    : "Shown in the paper's Fig. 5; recomputed here with current borders, so totals differ slightly (mainly Sudan and South Sudan)."} Climate: mean of the climate models, so country totals (${people(countryTotal)} in all) are lower than the global figure above. <a href="./methods">Why</a>.</div>
  <div class="legend">
    <span class="key"><span class="swatch" style="background: var(--hot)"></span>At ${degrees(warming)}</span>
    ${warming !== 1.5 ? html`<span class="key"><span class="tickmark" style="background: var(--reference)"></span>At 1.5 °C</span>` : ""}
  </div>
  ${resize((width) => countryBars({rows: rowsAt, rows15, level: warming, width}))}
</div>

```js
const tableRows = rowsAt
  .map((d) => ({
    Country: d.name,
    "Exposed (million)": d["exposed_9.5bn"] / 1e6,
    "Share of people": d["population_9.5bn"] > 0 ? (d["exposed_9.5bn"] / d["population_9.5bn"]) * 100 : 0,
    "Share of land": d.exposed_land_pct,
    "At 1.5 °C (million)": (rows15.find((r) => r.id === d.id)?.["exposed_9.5bn"] ?? 0) / 1e6,
    "Population 2070 (million)": d["population_9.5bn"] / 1e6
  }))
  .sort((a, b) => b["Exposed (million)"] - a["Exposed (million)"]);
const search = view(Inputs.search(tableRows, {placeholder: "Search countries", label: "All countries"}));
```

```js
Inputs.table(search, {
  rows: 12,
  layout: "auto",
  format: {
    "Exposed (million)": (x) => millions(x * 1e6),
    "Share of people": (x) => pct(x),
    "Share of land": (x) => pct(x),
    "At 1.5 °C (million)": (x) => millions(x * 1e6),
    "Population 2070 (million)": (x) => millions(x * 1e6)
  }
})
```

<p class="caption">People in a world of 9.5 billion (SSP2 population for 2070). "Share of land" is the part of the country's area with a mean annual temperature of 29 °C or more. Download the full table from the <a href="./methods">methods page</a>.</p>
