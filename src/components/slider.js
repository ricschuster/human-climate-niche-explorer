// The global warming slider. The track is proportional to temperature, but the
// value always snaps to one of the paper's warming levels; arrow keys move to
// the next or previous level. Works with Framework's view(): the returned
// element has a `value` and emits "input" events.

const SHORT_POLICY = {
  "Paris Agreement goal": "Paris goal",
  "All announced targets met": "All targets",
  "Binding long-term targets": "Binding targets",
  "2030 NDCs only": "2030 NDCs",
  "Current policies": "Current policies",
  "Worst case": "Worst case"
};

export function warmingSlider(levels, {value = 2.7, label = "Global warming"} = {}) {
  const sorted = [...levels].sort((a, b) => a.warming - b.warming);
  const min = sorted[0].warming;
  const max = sorted[sorted.length - 1].warming;
  const id = `warming-${Math.random().toString(36).slice(2, 8)}`;

  const form = document.createElement("form");
  form.className = "warming-slider";
  form.addEventListener("submit", (event) => event.preventDefault());

  const readout = document.createElement("div");
  readout.className = "readout";
  const lab = document.createElement("label");
  lab.htmlFor = id;
  lab.textContent = label;
  const output = document.createElement("output");
  output.htmlFor = id;
  const scenario = document.createElement("span");
  scenario.className = "scenario";
  readout.append(lab, output, scenario);

  const input = document.createElement("input");
  input.type = "range";
  input.id = id;
  input.min = String(min);
  input.max = String(max);
  input.step = "0.1";

  const ticks = document.createElement("div");
  ticks.className = "ticks";
  ticks.setAttribute("aria-hidden", "true");
  const tickEls = new Map();
  for (const level of sorted) {
    const tick = document.createElement("div");
    tick.className = "tick";
    tick.style.left = `${((level.warming - min) / (max - min)) * 100}%`;
    // 2.0 sits 0.1 C from 2.1; leave it unlabelled so labels never collide.
    tick.textContent = level.policy ? level.warming.toFixed(1) : "";
    // Only the two cases the paper contrasts get a label under the track; the
    // readout names the policy case of whichever level is selected.
    if (level.policy === "Paris Agreement goal" || level.policy === "Current policies") {
      const p = document.createElement("span");
      p.className = "policy";
      p.textContent = SHORT_POLICY[level.policy] ?? level.policy;
      tick.append(p);
    }
    tick.addEventListener("click", () => set(level.warming, true));
    ticks.append(tick);
    tickEls.set(level.warming, tick);
  }

  form.append(readout, input, ticks);

  function nearest(v) {
    return sorted.reduce((best, l) => (Math.abs(l.warming - v) < Math.abs(best.warming - v) ? l : best), sorted[0]);
  }

  function set(v, emit) {
    const level = nearest(v);
    form.value = level.warming;
    input.value = String(level.warming);
    output.textContent = `${level.warming.toFixed(1)} °C`;
    const parts = [level.policy, level.ssp && `${level.ssp}, ${level.period}`].filter(Boolean);
    scenario.textContent = parts.join(" · ");
    input.setAttribute("aria-valuetext", `${level.warming.toFixed(1)} degrees C, ${parts.join(", ")}`);
    for (const [w, el] of tickEls) el.classList.toggle("selected", w === level.warming);
    if (emit) form.dispatchEvent(new Event("input", {bubbles: true}));
  }

  input.addEventListener("input", (event) => {
    event.stopPropagation();
    set(Number(input.value), true);
  });
  input.addEventListener("keydown", (event) => {
    const i = sorted.findIndex((l) => l.warming === form.value);
    let j = i;
    if (event.key === "ArrowRight" || event.key === "ArrowUp") j = Math.min(i + 1, sorted.length - 1);
    else if (event.key === "ArrowLeft" || event.key === "ArrowDown") j = Math.max(i - 1, 0);
    else if (event.key === "Home") j = 0;
    else if (event.key === "End") j = sorted.length - 1;
    else return;
    event.preventDefault();
    if (j !== i) set(sorted[j].warming, true);
  });

  set(value, false);
  return form;
}
