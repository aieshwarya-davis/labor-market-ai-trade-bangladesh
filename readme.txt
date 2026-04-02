# Labor Market Exposure to AI and Trade — Bangladesh (2022)

Analysis of labor market structure, AI occupational exposure, and import tariff patterns 
across South Asian countries, using the Bangladesh Labor Force Survey (2022) and WITS tariff data.

## Structure

- `/code` — Stata do file. Set `global root` at the top before running.
- `/data` — Public-domain input files (crosswalk, shapefiles, tariff data). 
  LFS microdata not included; see data/README_data.md for access.
- `/output` — Generated tables and matrices.
- `/figures` — All charts and maps.
- `/analytical_briefs` — Written briefs responding to each analytical task.

## Requirements

Stata 17+. The following user-written commands must be installed:
- `shp2dta` (ssc install shp2dta)
- `spmap` (ssc install spmap)
- `binscatter` (ssc install binscatter)

## Data sources

- Bangladesh LFS 2022: Bangladesh Bureau of Statistics
- MFN tariffs: World Integrated Trade Solution (WITS), latest year available per country
- Bangladesh shapefiles: GADM v4.1 (gadm.org)
- AI occupational exposure: Felten, Raj, Seamans (2023), AIOE scores crosswalked from SOC-10 to ISCO-08