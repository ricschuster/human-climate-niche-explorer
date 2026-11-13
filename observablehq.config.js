// Observable Framework configuration. See https://observablehq.com/framework/config
export default {
  title: "Human Climate Niche Explorer",
  root: "src",
  pages: [
    {name: "Explore", path: "/"},
    {name: "Methods and sources", path: "/methods"}
  ],
  theme: ["air", "near-midnight"],
  style: "style.css",
  head: '<meta name="description" content="How many people would live outside the human climate niche at each level of global warming: an interactive guide to Lenton, Xu et al. (2023), Nature Sustainability.">',
  footer:
    'Data and findings: Lenton, T. M., Xu, C., Abrams, J. F. et al. (2023). <a href="https://doi.org/10.1038/s41893-023-01132-6">Quantifying the human cost of global warming</a>. <i>Nature Sustainability</i> 6, 1237-1247, CC BY 4.0. Country borders: Natural Earth. This site is an independent visualization, not a publication of the authors.',
  sidebar: false,
  toc: false,
  pager: false,
  search: false,
  linkify: true
};
