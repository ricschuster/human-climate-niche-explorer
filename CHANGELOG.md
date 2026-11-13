# Changelog

All notable changes to this project are documented here. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added

- GitHub Pages deploy workflow; the site redeploys on every merge to `main`
  (`docs/design/02_site.md`, Deployment).
- Project brief with audience, MVP and later layers; ADR 0003 choosing a
  static Observable Framework site on GitHub Pages, with full-resolution
  raster map layers.
- ADR 0004: reconstructed the paper's country aggregation method (reproduces
  Fig. 5 exactly) and chose Natural Earth borders for published results.
- `download_data.sh` also fetches Natural Earth and World Borders boundaries.
- Project harness from `ricschuster/claude-project-template`: Claude Code
  working rules, CI hygiene checks, issue and PR templates, ADRs, design notes
  and handoffs.
- Source paper, Nature supplementary files, and the authors' original code.
- `scripts/download_data.sh` to fetch the raw data deposit (about 1.7 GB, not
  committed).
