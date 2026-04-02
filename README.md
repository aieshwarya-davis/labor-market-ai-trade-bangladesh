# Labor Market Exposure to AI and Trade — Bangladesh (2022)

Analysis of labor market structure, AI occupational exposure, and import tariff 
patterns across South Asian countries, using the Bangladesh Labor Force Survey 
(2022) and WITS tariff data.

## Overview

This project was completed as a technical assessment covering four analytical tasks:

1. Mapping employment and median wages across 18 sectors and 13 occupational groups
2. Mapping the share of agricultural workers by administrative division
3. Estimating AI occupational exposure by sector, education level, and urban/rural location
4. Compiling and comparing MFN import tariffs across eight South Asian countries

## Repository Structure
```
├── code/
│   └── labor_market_ai_trade_analysis.do   
├── data/
│   ├── README_data.md                       
│   ├── occ_crosswalk.xlsx                   
│   ├── Language_Modeling_AIOE_and_AIIE.xlsx 
│   ├── south_asia_mfn_tariffs.csv           
│   ├── hs6_unique_codes_for_mapping.csv     
│   └── gadm41_BGD_1.*                       
├── output/                                  
├── figures/                                 
└── analytical_briefs/                       
```

## Requirements

Stata 17 or later. The following user-written commands must be installed:
```stata
ssc install shp2dta
ssc install spmap
ssc install binscatter
```

## Replication

1. Download the Bangladesh LFS 2022 microdata from the World Bank Microdata Library
   and place it at `data/data.dta` — see `data/README_data.md` for details
2. Update `global root` at the top of the do file to your local path
3. Run `labor_market_ai_trade_analysis.do` in full

All outputs and figures will be regenerated in the corresponding folders.

## Data Sources

- Bangladesh LFS 2022: Bangladesh Bureau of Statistics via World Bank Microdata Library
- MFN tariffs: World Integrated Trade Solution (WITS), latest year available per country
- Bangladesh shapefiles: GADM v4.1 (gadm.org)
- AI occupational exposure: Felten, Raj, and Seamans (2023), AIOE scores crosswalked 
  from SOC-10 to ISCO-08 via ILO concordance

## Author

Aieshwarya Davis  
aieshwaryadavis@gmail.com
