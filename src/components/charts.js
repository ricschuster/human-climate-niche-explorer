// Charts, built with Observable Plot. Colours come from CSS variables in
// style.css, so light and dark mode each use their own validated steps.
import * as Plot from "npm:@observablehq/plot";
import {millions} from "./format.js";

const HOT = "var(--hot)";
const REFERENCE = "var(--reference)";
const CONTEXT = "var(--context)";
const GRID = {stroke: "var(--hairline)", strokeOpacity: 1};

// Fig. 3: one panel per metric. Model runs as dots, the paper's regression line
// with its 95% confidence band, the selected level's runs and mean in orange.
export function exposureVsWarming({models, fit, summary, metric, level, width, height = 260, yMax}) {
  const runs = models.filter((d) => d.metric === metric);
  const line = fit.filter((d) => d.metric === metric && d.warming >= 1 && d.warming <= 4.4);
  const mean = summary.filter((d) => d.metric === metric);
  const selected = mean.find((d) => d.warming === level);
  return Plot.plot({
    width,
    height,
    marginLeft: 40,
    marginRight: 12,
    x: {label: "Global warming (°C) →", domain: [0.9, 4.5], ticks: [1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5]},
    y: {label: "↑ % of 9.5 billion people", domain: [0, yMax], grid: true, ...GRID},
    marks: [
      Plot.areaY(line, {x: "warming", y1: "lo", y2: "hi", fill: CONTEXT, fillOpacity: 0.12}),
      Plot.lineY(line, {x: "warming", y: "fit", stroke: CONTEXT, strokeWidth: 2}),
      Plot.ruleX([level], {stroke: HOT, strokeOpacity: 0.35}),
      Plot.dot(
        runs.filter((d) => d.warming !== level),
        {x: "warming", y: "pct", r: 3, fill: CONTEXT, fillOpacity: 0.55}
      ),
      Plot.dot(
        runs.filter((d) => d.warming === level),
        {x: "warming", y: "pct", r: 4, fill: HOT, stroke: "var(--theme-background)", strokeWidth: 2}
      ),
      selected
        ? Plot.text([selected], {
            x: "warming",
            y: "pct_p95",
            text: (d) => `${d.pct_mean.toFixed(0)}%`,
            dy: -10,
            fontWeight: 600,
            fill: "currentColor"
          })
        : null,
      Plot.tip(
        runs,
        Plot.pointer({
          x: "warming",
          y: "pct",
          channels: {"Climate model run": "model"},
          format: {x: (d) => `${d} °C`, y: (d) => `${d.toFixed(1)}%`}
        })
      )
    ]
  });
}

// Fig. 1c: population density against MAT, reference niche vs selected level.
export function nicheCurve({curves, level, width, height = 300}) {
  const ref = curves.filter((d) => d.curve === "reference");
  const sel = curves.filter((d) => d.curve === "warming" && d.population === "9.5bn" && d.warming === level);
  const both = [...ref.map((d) => ({...d, series: "Reference niche (1960-1990)"})), ...sel.map((d) => ({...d, series: `${level.toFixed(1)} °C, 9.5 billion people`}))];
  return Plot.plot({
    width,
    height,
    marginLeft: 16,
    marginRight: 12,
    x: {label: "Mean annual temperature (°C) →", domain: [-5, 36]},
    y: {label: null, ticks: [], domain: [0, Math.max(1.8, ...both.map((d) => d.p95))]},
    marks: [
      Plot.ruleX([29], {stroke: CONTEXT, strokeWidth: 1}),
      Plot.text([29], {x: 29, frameAnchor: "top", text: () => "29 °C", dx: -4, textAnchor: "end", fill: "var(--theme-foreground-muted)", dy: 4}),
      Plot.areaY(ref, {x: "mat", y1: "p5", y2: "p95", fill: REFERENCE, fillOpacity: 0.12, curve: "monotone-x"}),
      Plot.areaY(sel, {x: "mat", y1: "p5", y2: "p95", fill: HOT, fillOpacity: 0.12, curve: "monotone-x"}),
      Plot.lineY(ref, {x: "mat", y: "mean", stroke: REFERENCE, strokeWidth: 2, curve: "monotone-x"}),
      Plot.lineY(sel, {x: "mat", y: "mean", stroke: HOT, strokeWidth: 2, curve: "monotone-x"}),
      Plot.ruleY([0], {stroke: "var(--hairline)"}),
      Plot.tip(
        both,
        Plot.pointerX({
          x: "mat",
          y: "mean",
          channels: {Curve: "series", Window: (d) => `${d.mat_lo} to ${d.mat_hi} °C`},
          format: {x: false, y: (d) => d.toFixed(2)}
        })
      )
    ]
  });
}

// Fig. 5: top countries by people exposed at the selected level (bars), with
// the 1.5 °C value as a tick for comparison.
export function countryBars({rows, rows15, level, width, top = 15}) {
  const at15 = new Map(rows15.map((d) => [d.id, d["exposed_9.5bn"]]));
  const data = rows
    .filter((d) => d["exposed_9.5bn"] > 0)
    .sort((a, b) => b["exposed_9.5bn"] - a["exposed_9.5bn"])
    .slice(0, top)
    .map((d) => ({...d, at15: at15.get(d.id) ?? 0}));
  const showTick = level !== 1.5;
  const marginLeft = Math.min(150, width * 0.32);
  const maxChars = Math.floor((marginLeft - 8) / 6.5); // ~6.5 px per character at 12px
  const short = (name) => (name.length > maxChars ? `${name.slice(0, maxChars - 1)}…` : name);
  return Plot.plot({
    width,
    height: Math.max(120, data.length * 26 + 40),
    marginLeft,
    marginRight: 48,
    x: {label: "People exposed (million) →", grid: true, ...GRID, tickFormat: (d) => (d / 1e6).toLocaleString("en-US")},
    y: {label: null, domain: data.map((d) => d.name), tickSize: 0, tickFormat: short},
    marks: [
      Plot.barX(data, {y: "name", x: "exposed_9.5bn", fill: HOT, insetTop: 4, insetBottom: 4}),
      Plot.text(data, {y: "name", x: "exposed_9.5bn", text: (d) => millions(d["exposed_9.5bn"]), dx: 4, textAnchor: "start", fill: "currentColor"}),
      showTick ? Plot.tickX(data, {y: "name", x: "at15", stroke: REFERENCE, strokeWidth: 2}) : null,
      Plot.ruleX([0], {stroke: "var(--context)"}),
      Plot.tip(
        data,
        Plot.pointerY({
          y: "name",
          x: "exposed_9.5bn",
          channels: {
            Country: "name",
            [`At ${level.toFixed(1)} °C`]: (d) => `${millions(d["exposed_9.5bn"])} million`,
            "At 1.5 °C": (d) => `${millions(d.at15)} million`,
            "Share of land": (d) => `${d.exposed_land_pct.toFixed(0)}%`
          },
          format: {x: false, y: false}
        })
      )
    ]
  });
}
