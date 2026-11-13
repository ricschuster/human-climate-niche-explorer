// Number formatting shared by every view. People counts are rounded the way
// the paper quotes them: billions to one decimal, millions to whole numbers.

export function people(n) {
  if (n == null || Number.isNaN(n)) return "n/a";
  if (Math.abs(n) >= 1e9) return `${(n / 1e9).toFixed(1)} billion`;
  if (Math.abs(n) >= 1e6) return `${Math.round(n / 1e6).toLocaleString("en-US")} million`;
  if (Math.abs(n) >= 1e3) return `${Math.round(n / 1e3).toLocaleString("en-US")} thousand`;
  return Math.round(n).toLocaleString("en-US");
}

// Same, but the number and unit apart (for the hero figure).
export function peopleParts(n) {
  if (Math.abs(n) >= 1e9) return [(n / 1e9).toFixed(1), "billion"];
  return [Math.round(n / 1e6).toLocaleString("en-US"), "million"];
}

// Millions on an axis or in a table: 613 M.
export function millions(n) {
  if (n == null || Number.isNaN(n)) return "n/a";
  const m = n / 1e6;
  return m >= 10 ? Math.round(m).toLocaleString("en-US") : m >= 0.05 ? m.toFixed(1) : m > 0 ? "<0.1" : "0";
}

export function pct(p, digits = 0) {
  if (p == null || Number.isNaN(p)) return "n/a";
  return `${p.toFixed(digits)}%`;
}

export function degrees(w) {
  return `${Number(w).toFixed(1)} °C`;
}
