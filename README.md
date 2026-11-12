# Human Climate Niche Explorer

Interactive visualization of the results in:

> Lenton, T. M., Xu, C., Abrams, J. F., et al. (2023). Quantifying the human cost of global warming.
> *Nature Sustainability* 6, 1237–1247. https://doi.org/10.1038/s41893-023-01132-6

The paper describes the "human climate niche", the historically stable distribution of human population
density with respect to mean annual temperature (MAT). It estimates how many people fall outside that niche
under different Shared Socioeconomic Pathways (SSP1-2.6, SSP2-4.5, SSP3-7.0, SSP5-8.5) and warming levels
(1.5–4.4 °C).

## Repository layout

| Path | Contents | In git? |
|---|---|---|
| `paper/` | The article PDF (CC BY 4.0) | yes |
| `data/supplementary/` | Nature supplementary info, reporting summary, country-level results (xlsx) | yes |
| `data/raw/` | Authors' figshare data deposit (~1.7 GB, `.mat` files) | **no**, see below |
| `data/processed/` | Small derived files used by the visualization | yes |
| `reference/authors_code/` | Authors' original MATLAB / Python / R code (figshare, CC BY 4.0) | yes |
| `scripts/` | Data download and processing scripts | yes |

## Getting the raw data

```bash
./scripts/download_data.sh
```

The script downloads the data deposit from [figshare (10.6084/m9.figshare.22650361)](https://doi.org/10.6084/m9.figshare.22650361)
and the supplementary files from the Nature article page.

## Sources and licensing

- Article: © The Author(s) 2023, [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)
- Data: https://doi.org/10.6084/m9.figshare.22650361 (CC BY 4.0)
- Code: https://doi.org/10.6084/m9.figshare.22650760 (CC BY 4.0)
