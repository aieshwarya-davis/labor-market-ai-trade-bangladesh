# Data Notes

## Labor Force Survey (data.dta)
Not included in this repository. The Bangladesh Labor Force Survey 2022 microdata 
is available through the World Bank Microdata Library:
https://microdata.worldbank.org

Download requires registration and agreement to the terms of use. Once downloaded, 
place the file at data/data.dta before running the do file.

## Tariff data
`south_asia_mfn_tariffs.csv` was compiled from WITS (World Bank) using the following 
vintages — the latest year available per country at the time of analysis:

| Country | Year | HS Nomenclature |
|---------|------|-----------------|
| AFG     | 2018 | H4              |
| BGD     | 2023 | H5              |
| BTN     | 2022 | H6              |
| IND     | 2023 | H6              |
| LKA     | 2023 | H6              |
| MDV     | 2023 | H6              |
| NPL     | 2023 | H6              |
| PAK     | 2023 | H6              |

Raw files were downloaded from: https://wits.worldbank.org

**Pakistan textiles note:** The WITS Pakistan file does not include tariff lines for 
vegetable oil chapters (HS 1507–1516), reducing textile sector line coverage to 31 
lines versus ~69 for other countries. Averages are computed from available data.

## AI exposure scores
Source: Felten, Raj, and Seamans (2023). AIOE scores were originally coded under the 
U.S. SOC-10 classification and crosswalked to ISCO-08 using the official ILO concordance 
provided in `occ_crosswalk.xlsx`.

Approximately 10% of LFS observations could not be matched, predominantly ISCO 6300 
(subsistence fishery and agriculture workers). These are excluded from AI exposure 
aggregations.

## Shapefiles
Bangladesh admin-1 division boundaries sourced from GADM v4.1:
https://gadm.org

Files: gadm41_BGD_1.shp/.dbf/.prj/.shx/.cpg