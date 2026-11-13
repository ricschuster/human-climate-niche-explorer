// MapLibre map: population density and unprecedented-heat rasters (already in
// Web Mercator, split into western and eastern halves) under a country layer
// for hover. No basemap: the land and country layers are the whole map.
import maplibregl from "npm:maplibre-gl@5.24.0";
import {millions, pct} from "./format.js";

const HALVES = ["w", "e"];

export async function createMap(container, {layers, population, hot, countries, lineColor}) {
  // The container may not be in the page (or sized) yet when this runs.
  if (!container.isConnected || container.clientWidth === 0) {
    await new Promise((resolve) => {
      const ro = new ResizeObserver(() => {
        if (container.isConnected && container.clientWidth > 0) {
          ro.disconnect();
          resolve();
        }
      });
      ro.observe(container);
    });
  }
  const map = new maplibregl.Map({
    container,
    style: {version: 8, sources: {}, layers: []},
    bounds: [
      [-165, -56],
      [178, 76]
    ],
    renderWorldCopies: false,
    attributionControl: false,
    dragRotate: false,
    pitchWithRotate: false,
    touchPitch: false,
    minZoom: 0,
    maxZoom: 7,
    cooperativeGestures: matchMedia("(pointer: coarse)").matches
  });
  // Keep the canvas in step with the container (layout shifts, card resizes).
  const resizer = new ResizeObserver(() => map.resize());
  resizer.observe(container);
  map.on("remove", () => resizer.disconnect());
  map.touchZoomRotate.disableRotation();
  map.keyboard.disableRotation();
  map.addControl(new maplibregl.NavigationControl({showCompass: false}), "top-right");
  map.addControl(
    new maplibregl.AttributionControl({
      compact: true,
      customAttribution: "Data: Lenton et al. (2023), CC BY 4.0 · Borders: Natural Earth"
    })
  );
  await new Promise((resolve) => map.once("load", resolve));

  for (const half of HALVES) {
    const coordinates = layers.coordinates[half];
    map.addSource(`population-${half}`, {type: "image", url: population[half], coordinates});
    map.addLayer({
      id: `population-${half}`,
      type: "raster",
      source: `population-${half}`,
      paint: {"raster-resampling": "nearest", "raster-fade-duration": 0}
    });
  }
  for (const half of HALVES) {
    map.addSource(`hot-${half}`, {type: "image", url: hot[half], coordinates: layers.coordinates[half]});
    map.addLayer({
      id: `hot-${half}`,
      type: "raster",
      source: `hot-${half}`,
      paint: {"raster-resampling": "nearest", "raster-fade-duration": 0, "raster-opacity": 0.8}
    });
  }
  map.addSource("countries", {type: "geojson", data: countries, promoteId: "id"});
  map.addLayer({
    id: "country-fill",
    type: "fill",
    source: "countries",
    paint: {
      "fill-color": lineColor,
      "fill-opacity": ["case", ["boolean", ["feature-state", "hover"], false], 0.18, 0]
    }
  });
  map.addLayer({
    id: "country-line",
    type: "line",
    source: "countries",
    paint: {"line-color": lineColor, "line-width": 0.5, "line-opacity": 0.5}
  });

  // Hover readout. The current level's rows are swapped in by setLevel().
  let rows = new Map();
  let level = null;
  let hovered = null;
  const popup = new maplibregl.Popup({closeButton: false, closeOnClick: false, offset: 12, maxWidth: "260px"});
  const clear = () => {
    if (hovered != null) map.setFeatureState({source: "countries", id: hovered}, {hover: false});
    hovered = null;
    popup.remove();
  };
  map.on("mousemove", "country-fill", (event) => {
    const feature = event.features?.[0];
    if (!feature) return;
    if (hovered !== feature.id) {
      clear();
      hovered = feature.id;
      map.setFeatureState({source: "countries", id: hovered}, {hover: true});
    }
    map.getCanvas().style.cursor = "default";
    popup.setLngLat(event.lngLat).setDOMContent(readout(feature, rows.get(feature.id), level)).addTo(map);
  });
  map.on("mouseleave", "country-fill", clear);

  return {
    map,
    setHot(urls) {
      for (const half of HALVES) map.getSource(`hot-${half}`).updateImage({url: urls[half], coordinates: layers.coordinates[half]});
    },
    setPopulation(urls) {
      for (const half of HALVES) map.getSource(`population-${half}`).updateImage({url: urls[half], coordinates: layers.coordinates[half]});
    },
    setLineColor(color) {
      map.setPaintProperty("country-line", "line-color", color);
      map.setPaintProperty("country-fill", "fill-color", color);
    },
    setLevel(newLevel, newRows) {
      level = newLevel;
      rows = newRows;
      clear();
    }
  };
}

// Built with textContent: names come from data files.
function readout(feature, row, level) {
  const div = document.createElement("div");
  const name = document.createElement("strong");
  name.textContent = row?.name ?? feature.properties.name;
  div.append(name);
  const line = (text) => {
    const p = document.createElement("div");
    p.textContent = text;
    div.append(p);
  };
  if (!row) {
    line("No grid data");
    return div;
  }
  const share = row["population_9.5bn"] > 0 ? (row["exposed_9.5bn"] / row["population_9.5bn"]) * 100 : 0;
  line(`${millions(row["exposed_9.5bn"])} million people in unprecedented heat at ${level.toFixed(1)} °C`);
  line(`${pct(share)} of the country's people, ${pct(row.exposed_land_pct)} of its land`);
  return div;
}
