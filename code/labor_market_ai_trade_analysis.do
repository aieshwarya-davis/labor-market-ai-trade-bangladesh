* =====================================================
* Labor Market Exposure to AI and Trade in South Asia
* Bangladesh Labor Force Survey (2022) | WITS Tariff Data
* Author: Aieshwarya Davis
* Last updated: June 2025
* =====================================================

* ---- Setting up Environment  ----
clear
clear mata
clear matrix

// Set maximum variables and memory
set maxvar 32767
set more off
set linesize 255
set varabbrev off
set seed 12345

// Establish directory structure using globals
//Set your root directory here before running
//global root "YOUR_ROOT_PATH_HERE"
global root "C:\Users\wb524765\OneDrive - WBG\Personal\SARCE_GE_test" // Update path
cap mkdir "$root"
cd "$root"

//Subdirectories
global temp "$root/temp"
global data "$root/data"
global output "$root/output"
global code "$root/code"
global figs "$root/figures"

// Create folders if they don't exist
foreach dir in data temp output code figs {
    cap mkdir "${`dir'}"
}

// Start log file
cap log close
log using "$output/labor_market_analysis_$S_DATE.smcl", replace

*====================================================================
* Create Cleaned Labor Force Dataset 
*====================================================================

use "$data/data.dta", clear

* Keep only employed individuals
keep if inlist(empstat, 1, 2, 3, 4)

* Generate clean wage variable
gen wage_clean = wage_no_compen if wage_no_compen > 0 & !missing(wage_no_compen)

* Convert 4-digit ISCO occupation code from string to numeric
destring occup_isco, gen(isco08_code) force

* Keep only needed variables
keep pid hhid isco08_code wage_clean educat4 urban weight empstat industrycat2d occup_isco2d subnatid1

* Save cleaned dataset
save "$output/cleaned_lfs.dta", replace


*====================================================================
* TASK 1: LABOR MARKET DESCRIPTION
*====================================================================
//A. Construction of Employment Mapping

* ---- Load Dataset ----
use "$data/data.dta", clear

* ---- Inspect Data ----

describe
summarize
ds

* Quick tabulations to inspect key variables
tab industrycat2d if !missing(industrycat2d), sort
tab occup_isco2d if !missing(occup_isco2d), sort
tab unitwage if !missing(unitwage), sort

* ---- Clean and Prepare Variables ----

//Sector Grouping 

* Convert industrycat2d from string to numeric
destring industrycat2d, generate(industrycat2d_num) force

* Recode into 18 sector groups (from Table 1 in assignment)

gen sector_group = .

* Agriculture 
replace sector_group = 1 if inrange(industrycat2d_num, 1, 4)
* Non-manufacturing industry
replace sector_group = 2 if inrange(industrycat2d_num, 5, 9) | inrange(industrycat2d_num, 35, 44)
* Food and beverages 
replace sector_group = 3 if inrange(industrycat2d_num, 10, 12)
* Textiles 
replace sector_group = 4 if inrange(industrycat2d_num, 13, 15)
* Wood products 
replace sector_group = 5 if inrange(industrycat2d_num, 16, 18)
* Fuel, chemicals, and metals
replace sector_group = 6 if inrange(industrycat2d_num, 19, 25)
* Electronics, machinery, and transport equipment 
replace sector_group = 7 if inrange(industrycat2d_num, 26, 30)
* Other manufacturing 
replace sector_group = 8 if inrange(industrycat2d_num, 31, 33)
* Trade services
replace sector_group = 9 if inrange(industrycat2d_num, 45, 48)
* Accommodation and food services
replace sector_group = 10 if inrange(industrycat2d_num, 55, 57)
* Transportation and storage 
replace sector_group = 11 if inrange(industrycat2d_num, 49, 54)
* Information and communication 
replace sector_group = 12 if inrange(industrycat2d_num, 58, 63)
* Finance, insurance, and real estate 
replace sector_group = 13 if inrange(industrycat2d_num, 64, 68)
* Technical and administrative services
replace sector_group = 14 if inrange(industrycat2d_num, 69, 83)
* Public administration and defense 
replace sector_group = 15 if industrycat2d_num == 84
* Education 
replace sector_group = 16 if industrycat2d_num == 85
* Health and social work 
replace sector_group = 17 if inrange(industrycat2d_num, 86, 89)
* Other services 
replace sector_group = 18 if inrange(industrycat2d_num, 90, 99)


* Label the groups for clarity
label define sector_grp 1 "Agriculture" 2 "Non-manufacturing industry" 3 "Food and beverages" ///
    4 "Textiles" 5 "Wood products" 6 "Fuel/chemicals/metals" 7 "Electronics/machinery/transport" ///
    8 "Other manufacturing" 9 "Trade services" 10 "Accommodation & food" 11 "Transport & storage" ///
    12 "Information & comm" 13 "Finance & real estate" 14 "Tech/admin services" 15 "Public admin" ///
    16 "Education" 17 "Health & social work" 18 "Other services"
label values sector_group sector_grp

//Occupational Grouping

** Convert occup_isco2d_num from string to numeric
destring occup_isco2d, generate(occup_isco2d_num) force


* Recode occupation into 13 groups (from Table 2)

gen occupation_group = .

* 1. Legislators
replace occupation_group = 1 if occup_isco2d_num == 11
* 2. Managers
replace occupation_group = 2 if inrange(occup_isco2d_num, 12, 14)
* 3. Engineering professionals
replace occupation_group = 3 if inlist(occup_isco2d_num, 21, 25, 31)
* 4. Health professionals
replace occupation_group = 4 if inlist(occup_isco2d_num, 22, 32)
* 5. Teaching professionals
replace occupation_group = 5 if occup_isco2d_num == 23
* 6. Other professionals
replace occupation_group = 6 if inlist(occup_isco2d_num, 24, 26, 33, 34, 35)
* 7. Clerical support workers
replace occupation_group = 7 if inrange(occup_isco2d_num, 41, 44)
* 8. Personal service workers
replace occupation_group = 8 if inlist(occup_isco2d_num, 51, 53, 54, 91, 94, 96)
* 9. Sales workers
replace occupation_group = 9 if inlist(occup_isco2d_num, 52, 95)
* 10. Craft workers and machine operators
replace occupation_group = 10 if inrange(occup_isco2d_num, 71, 82) | occup_isco2d_num == 93
* 11. Agricultural workers
replace occupation_group = 11 if inlist(occup_isco2d_num, 61, 62, 63, 92)
* 12. Other (incl. armed forces)
replace occupation_group = 12 if inrange(occup_isco2d_num, 1, 3)
* 13. Drivers and mobile plant operators
replace occupation_group = 13 if occup_isco2d_num == 83

*Labels the groups for clarity
label define occ_grp 1 "Legislators" 2 "Managers" 3 "Engineering profs" 4 "Health profs" ///
    5 "Teaching profs" 6 "Other profs" 7 "Clerical" 8 "Personal services" 9 "Sales" ///
    10 "Craft/machine ops" 11 "Agri workers" 12 "Other/armed forces" 13 "Drivers"
label values occupation_group occ_grp

*Check to see the type of employment status
tab empstat, missing

*Cleaning data 

* Keep only individuals who are employed (paid employee, non-paid, employer, self-employed)
keep if inlist(empstat, 1, 2, 3, 4)

* Create clean wage variable (non-missing and greater than 0)
gen wage_clean = wage_no_compen if wage_no_compen > 0 & !missing(wage_no_compen)

* Drop observations with unclassified sector or occupation
drop if missing(sector_group, occupation_group)


* ---- Create Employment Mapping Matrix ----
* Create a matrix of total employment across sector and occupation groups (unweighted)
tabulate sector_group occupation_group, matcell(emp_matrix)

* Export as a readable unweighted dataset
preserve
gen obs_dummy = 1
collapse (count) workers=obs_dummy, by(sector_group occupation_group)
sort sector_group occupation_group
export delimited using "$output/employment_matrix.csv", replace
restore

* Export weighted matrix of total employment (population-level estimates)
preserve
collapse (sum) weighted_workers = weight, by(sector_group occupation_group)
sort sector_group occupation_group
export delimited using "$output/employment_matrix_weighted.csv", replace
restore

* Note:

* The weighted matrix reflects the estimated number of employed individuals in each sector–occupation combination in the national population,  using survey weights from the labor force dataset. These weights adjust for sampling design and allow inference to the full labor market. 


//B. Comparison of Median Wages by Sector and Occupation

*Note: For this exercise, wage comparisons will be made between sector and occupation, and also in the matrix. There will also be a comparison between the weighted and unweighted matrix to ensure cohesive reporting. 

//UNWEIGHTED 
* ---- Median Wages by Sector ----

preserve

* Keep only observations with valid, positive monthly wages
keep if !missing(wage_clean)

* Calculate median wage by sector
collapse (median) median_wage = wage_clean, by(sector_group)
sort sector_group

* Label sector groups for graph clarity
label values sector_group sector_grp

* Generate bar graph: Median wage by sector
graph bar median_wage, over(sector_group, label(angle(45))) ///
    ytitle("Median Monthly Wage (BDT)") ///
    title("Median Wages by Sector (BGD 2022)") ///
    bar(1, lcolor(black)) ///
    blabel(bar, format(%9.0g))

* Export graph and wage table
graph export "$figs/median_wage_by_sector.png", replace
export delimited using "$output/median_wage_by_sector.csv", replace

restore

* ---- Median Wages by Occupation ----

preserve

* Keep only observations with valid, positive monthly wages
keep if !missing(wage_clean)

* Calculate median wage by occupation
collapse (median) median_wage = wage_clean, by(occupation_group)
sort occupation_group

* Label occupation groups for graph clarity
label values occupation_group occ_grp

* Generate bar graph: Median wage by occupation
graph bar median_wage, over(occupation_group, label(angle(45))) ///
    ytitle("Median Monthly Wage (BDT)") ///
    title("Median Wages by Occupation (BGD 2022)") ///
    bar(1, lcolor(black)) ///
    blabel(bar, format(%9.0g))

* Export graph and wage table
graph export "$figs/median_wage_by_occupation.png", replace
export delimited using "$output/median_wage_by_occupation.csv", replace

restore

* ---- Median Wages by Sector x Occupation ---- 
preserve

* Keep only valid wage observations
keep if !missing(wage_clean)

* Collapse to median wage by sector and occupation
collapse (median) median_wage = wage_clean, by(sector_group occupation_group)
sort sector_group occupation_group

* Export for record
export delimited using "$output/median_wage_sector_occupation.csv", replace

* Label sector only (we'll keep occupation as plain numbers)
label define sector_lbl 1 "Agriculture" 2 "Non-mfg ind." 3 "Food & bev" 4 "Textiles" ///
    5 "Wood" 6 "Chem/metal" 7 "Machinery" 8 "Other mfg" 9 "Trade" 10 "Accom/food" ///
    11 "Transport" 12 "Info/comm" 13 "Finance" 14 "Admin" 15 "Public" ///
    16 "Education" 17 "Health" 18 "Other serv"
label values sector_group sector_lbl

* Remove occupation value labels so numbers show
label values occupation_group

* Plot with numeric x-axis and compact font note
graph bar median_wage, ///
    over(occupation_group, label(angle(0) labsize(vsmall))) ///
    by(sector_group, total row(3) subtitle("") ///
        note("1=Legisl., 2=Mgrs, 3=Engin., 4=Health, 5=Teachers, 6=Other Prof, 7=Clerical, 8=Pers. Serv, 9=Sales, 10=Craft/Ops, 11=Agri Workers, 12=Other/Forces, 13=Drivers", size(vsmall))) ///
    ytitle("") title("") ///
    bar(1, color(purple*0.8)) ///
    legend(off)


graph export "$figs/median_wage_faceted_by_sector.png", replace

restore

//WEIGHTED 

* ---- Weighted Median Wages by Sector ----

preserve

* Filter to valid wage and weight observations
keep if !missing(wage_clean, sector_group, weight)

* Sort within sector by wage to enable cumulative weight calculation
gsort sector_group wage_clean

* Cumulative weight within each sector group
bysort sector_group (wage_clean): gen cum_w = sum(weight)

* Total weight per sector group (value at last row of each group)
bysort sector_group (wage_clean): gen tot_w = cum_w[_N]

* Flag rows where cumulative weight first crosses the 50% threshold
gen flag = cum_w >= tot_w / 2

* Tag only the first crossing row per group (avoids flagging all rows above threshold)
bysort sector_group (wage_clean): gen tag = (flag & (_n == 1 | !flag[_n-1]))

* Retain exactly one row per sector — the weighted median observation
bysort sector_group: egen first_tag = min(cond(tag == 1, _n, .))
keep if _n == first_tag

* Clean up and rename for export
keep sector_group wage_clean
rename wage_clean median_wage
sort sector_group

* Label and plot
label values sector_group sector_grp
graph bar median_wage, over(sector_group, label(angle(45))) ///
    ytitle("Weighted Median Monthly Wage (BDT)") ///
    title("Weighted Median Wages by Sector (BGD 2022)") ///
    bar(1, lcolor(black)) ///
    blabel(bar, format(%3.0f))

graph export "$figs/weighted_median_wage_by_sector.png", replace
export delimited using "$output/weighted_median_wage_by_sector.csv", replace

restore
* ---- Weighted Median Wages by Occupation ----

preserve

* Filter to valid wage and weight observations
keep if !missing(wage_clean, occupation_group, weight)

* Sort within occupation by wage
gsort occupation_group wage_clean

* Cumulative weight within each occupation group
bysort occupation_group (wage_clean): gen cum_w = sum(weight)

* Total weight per occupation group
bysort occupation_group (wage_clean): gen tot_w = cum_w[_N]

* Flag rows where cumulative weight first crosses the 50% threshold
gen flag = cum_w >= tot_w / 2

* Tag only the first crossing row per group
bysort occupation_group (wage_clean): gen tag = (flag & (_n == 1 | !flag[_n-1]))

* Retain exactly one row per occupation — the weighted median observation
bysort occupation_group: egen first_tag = min(cond(tag == 1, _n, .))
keep if _n == first_tag

* Clean up and rename for export
keep occupation_group wage_clean
rename wage_clean median_wage
sort occupation_group

* Label and plot
label values occupation_group occ_grp
graph bar median_wage, over(occupation_group, label(angle(45))) ///
    ytitle("Weighted Median Monthly Wage (BDT)") ///
    title("Weighted Median Wages by Occupation (BGD 2022)") ///
    bar(1, lcolor(black)) ///
    blabel(bar, format(%3.0f))

graph export "$figs/weighted_median_wage_by_occupation.png", replace
export delimited using "$output/weighted_median_wage_by_occupation.csv", replace

restore
* ---- Weighted Median Wages by Sector x Occupation ----

preserve

* Filter to valid observations across all three dimensions
keep if !missing(wage_clean, sector_group, occupation_group, weight)

* Sort within sector-occupation cells by wage
gsort sector_group occupation_group wage_clean

* Cumulative weight within each sector-occupation cell
bysort sector_group occupation_group (wage_clean): gen cum_w = sum(weight)

* Total weight per cell
bysort sector_group occupation_group (wage_clean): gen tot_w = cum_w[_N]

* Flag rows where cumulative weight first crosses the 50% threshold
gen flag = cum_w >= tot_w / 2

* Tag only the first crossing row per cell
bysort sector_group occupation_group (wage_clean): ///
    gen tag = (flag & (_n == 1 | !flag[_n-1]))

* Retain exactly one row per sector-occupation cell — the weighted median observation
bysort sector_group occupation_group: ///
    egen first_tag = min(cond(tag == 1, _n, .))
keep if _n == first_tag

* Clean up and rename for export
keep sector_group occupation_group wage_clean
rename wage_clean median_wage
sort sector_group occupation_group

* Export the sector x occupation weighted median matrix
export delimited using "$output/weighted_median_wage_sector_occupation.csv", replace

* Apply short sector labels for faceted plot readability
label define sector_lbl 1 "Agriculture" 2 "Non-mfg ind." 3 "Food & bev" ///
    4 "Textiles" 5 "Wood" 6 "Chem/metal" 7 "Machinery" 8 "Other mfg" ///
    9 "Trade" 10 "Accom/food" 11 "Transport" 12 "Info/comm" ///
    13 "Finance" 14 "Admin" 15 "Public" 16 "Education" ///
    17 "Health" 18 "Other serv"
label values sector_group sector_lbl

* Strip occupation labels so numeric codes display on x-axis
label values occupation_group

* Faceted bar chart — one panel per sector, occupation groups on x-axis
graph bar median_wage, ///
    over(occupation_group, label(angle(0) labsize(vsmall))) ///
    by(sector_group, total row(3) subtitle("") ///
        note("1=Legisl., 2=Mgrs, 3=Engin., 4=Health, 5=Teachers, 6=Other Prof, 7=Clerical, 8=Pers. Serv, 9=Sales, 10=Craft/Ops, 11=Agri Workers, 12=Other/Forces, 13=Drivers", ///
        size(vsmall))) ///
    ytitle("") title("") ///
    bar(1, color(navy*0.8)) ///
    legend(off)

graph export "$figs/weighted_median_wage_faceted_by_sector.png", replace

restore

*====================================================================
* TASK 2: MAP TO SHOW FRACTION OF AGRI WORKERS
*====================================================================

* ---- Calculate Agricultural Share by Division ----

preserve

* Keep only employed and valid geographic records
keep if !missing(sector_group) & !missing(subnatid1)

* Flag agricultural workers (sector group 1 = Agriculture)
gen is_agriculture = sector_group == 1

* Create weighted counts
gen wgt_total = weight
gen wgt_agri = weight if is_agriculture == 1

* Collapse to get total and agricultural worker counts by division
collapse (sum) total_workers = wgt_total ///
         (sum) agri_workers = wgt_agri, by(subnatid1)

* Calculate agriculture share (as a percentage)
gen agri_share = 100 * agri_workers / total_workers

* Save intermediate dataset
save "$output/agri_share_by_division.dta", replace

restore

* ---- Load and Convert Shapefile ----

* Install shp2dta if not already installed
cap which shp2dta
if _rc {
    ssc install shp2dta, replace
}

* Install spmap if not already installed
cap which spmap
if _rc {
    ssc install spmap, replace
}

* Convert shapefile for admin-1 divisions
shp2dta using "$data/bgd_shp/gadm41_BGD_1", ///
    database("$temp/bgd_map") ///
    coordinates("$temp/bgd_coords") ///
    genid(id) replace

* ---- Merge Agri Share Data with Map Shapefile ----

use "$temp/bgd_map.dta", clear

* Create a division key to match agri dataset format
gen subnatid1 = string(id*10) + " - " + NAME_1

* Merge with agri share data
merge 1:1 subnatid1 using "$output/agri_share_by_division.dta"

* Drop unmatched divisions (if any) and cleanup
drop if _merge == 2
drop _merge

* Save merged file
save "$temp/bgd_map_with_agri.dta", replace

* ---- Plot Map: Agricultural Share by Division ----

* Load the merged map file
use "$temp/bgd_map_with_agri.dta", clear

* Rename ID to match coordinate file (_ID)
rename id _ID

* Plot map of agricultural share (in percent)
spmap agri_share using "$temp/bgd_coords.dta", id(_ID) ///
    fcolor(Blues) clmethod(quantile) ///
    title("Share of Workers in Agriculture by Division (%)", size(medium)) ///
    legend(position(6) ring(0) size(small))

* Save map as image
graph export "$figs/agri_share_map.png", replace

*====================================================================
* TASK 3: AI AND THE LABOR MARKET
*====================================================================

* ---- Import and Clean Language Modeling Exposure Data ----

* Import exposure data
import excel "$data/Language Modeling AIOE and AIIE.xlsx", firstrow clear

* Clean SOC code
rename SOCCode soc_string
replace soc_string = trim(soc_string)
gen soc_code = real(subinstr(soc_string, "-", "", .))

* Rename and clean exposure score
rename Language* aioe
destring aioe, replace force
drop if missing(soc_code, aioe)
keep soc_code aioe
save "$temp/ai_exposure_soc10.dta", replace

* ---- Import and Clean Crosswalk (SOC-10 to ISCO-08) ----

*Import Crosswalk data
import excel "$data/occ_crosswalk.xlsx", sheet("Sheet1") firstrow clear
rename SOCCode2010 soc_string
rename ISCO08Code isco_string

* Clean and convert codes
replace soc_string = trim(soc_string)
replace soc_string = subinstr(soc_string, "-", "", .)
destring soc_string, gen(soc_code) force

replace isco_string = trim(isco_string)
destring isco_string, gen(isco08_code) force

* Keep essential fields
keep soc_code isco08_code
drop if missing(soc_code, isco08_code)
duplicates drop soc_code isco08_code, force


* Save cleaned crosswalk
save "$temp/soc10_to_isco08.dta", replace


* ---- Merge AI Exposure to ISCO-08 ----

* Merge exposure and ISCO codes
use "$temp/ai_exposure_soc10.dta", clear
merge 1:m soc_code using "$temp/soc10_to_isco08.dta"
drop if _merge == 2
drop _merge


* Collapse to unique score per ISCO code (average if duplicates)
collapse (mean) aioe, by(isco08_code)

* Save the final ISCO-based AI exposure scores
save "$temp/ai_exposure_isco08.dta", replace


* ---- Merge with Labor Force Survey ----

* Load cleaned labor force survey data
use "$output/cleaned_lfs.dta", clear

* Destring if needed
destring isco08_code, replace force

* Load AI exposure by ISCO-08
merge m:1 isco08_code using "$temp/ai_exposure_isco08.dta"

* Drop unmatched rows 
drop if _merge == 2
drop _merge

save "$temp/lfs_with_ai_scores.dta", replace

*Sanity Checks
tab isco08_code if missing(aioe)
hist aioe, percent bin(50) color(navy*0.6) title("Distribution of AI Exposure")
 *------------------------------------------------------------------------------
* NOTE ON MISSING AI EXPOSURE SCORES (aioe):
* - Total missing: 4,700 obs. (~10% of 39,000 total observations).
* - Majority (86%) of missing aioe are ISCO-08 code 6300 (subsistence agriculture/fishery workers).
* - These occupations are likely informal/low-tech, so AI exposure scores may not apply or are negligible.
* ------------------------------------------------------------------------------

* ---- Aggregate AI Exposure by Group ----


* Ensure aioe is non-missing and weighted
keep if !missing(aioe, weight)

* Save merged dataset
save "$temp/lfs_with_ai_scores_weighted.dta", replace

* Create 1-digit ISCO major group from 4-digit ISCO
preserve
gen isco1 = floor(isco08_code / 1000)

* By 1-digit ISCO major group (occupation category)
collapse (mean) aioe [pw=weight], by(isco1)
export delimited using "$output/ai_exposure_by_isco1.csv", replace
restore 

* By education category
preserve
collapse (mean) aioe [pw=weight], by(educat4)
export delimited using "$output/ai_exposure_by_education.csv", replace
restore

* By urban/rural
preserve
collapse (mean) aioe= aioe [pw=weight], by(urban)
export delimited using "$output/ai_exposure_by_urban.csv", replace
restore

* ---- Plot AI Exposure vs Log Real Wages ----

* Reload full dataset
use "$temp/lfs_with_ai_scores.dta", clear

* Generate log wage
gen log_wage = log(wage_clean)

* Keep only valid observations
keep if !missing(log_wage, aioe)

*Install binscatter in case not already installed
ssc install binscatter, replace

* Plot: Binned scatterplot
binscatter log_wage aioe, ///
    xtitle("AI Exposure (AIOE)") ///
    ytitle("Log Monthly Wage") ///
    title("Correlation Between AI Exposure and Wages")

* Save plot
graph export "$figs/ai_exposure_vs_logwage.png", replace


* =====================================================
* TASK 4: TRADE AND TARIFFS 
* =====================================================

* ---- Import Tariff Data from WITS ----

local files "JobID-68664_MFN_H6_BTN_2022.CSV JobID-70141_MFN_H6_LKA_2023.CSV JobID-70175_MFN_H6_MDV_2023.CSV JobID-70184_MFN_H6_NPL_2023.CSV JobID-70462_MFN_H5_BGD_2023.CSV JobID-70505_MFN_H6_IND_2023.CSV JobID-70511_MFN_H6_PAK_2023.CSV JobID-53466_MFN_H4_AFG_2018.CSV"

tempfile combined_tariffs
clear
save `combined_tariffs', emptyok

foreach file in `files' {
    di "Processing `file'"

    * Extract country ISO3 code from file name
    local underscore_pos = strpos("`file'", "_H6_")
    if `underscore_pos' == 0 {
        local underscore_pos = strpos("`file'", "_H5_")
    }
    if `underscore_pos' == 0 {
        local underscore_pos = strpos("`file'", "_H4_")
    }
    local country = substr("`file'", `underscore_pos' + 4, 3)

    * Import data
    import delimited "$data/WITS Data/Unzipped/`file'", varnames(1) encoding("UTF-8") clear stringcols(_all)

    * Standardize variable names
    rename *, lower
    foreach v in productcode simpleaverage {
        capture confirm variable `v'
        if _rc {
            capture rename product_code productcode
            capture rename simpleaveragerate simpleaverage
        }
    }

    * Keep relevant columns
    keep productcode simpleaverage
    rename (productcode simpleaverage) (hscode mfn_rate_str)

    * Standardize HS6 codes
    tostring hscode, replace force
    if "`country'" == "BGD" {
        replace hscode = substr(hscode + "0", 1, 6) if length(hscode) == 5
    }
    if "`country'" == "AFG" {
        replace hscode = substr(hscode + "0000", 1, 6) if length(hscode) == 4
    }
    replace hscode = substr(hscode, 1, 6)

    * Clean MFN rates
    replace mfn_rate_str = subinstr(mfn_rate_str, ",", ".", .)
    destring mfn_rate_str, gen(mfn_rate) force
    drop mfn_rate_str

    * Add country code
    gen country = upper("`country'")

    * Drop invalid rows
    drop if missing(hscode) | hscode == "TOTAL" | length(hscode) != 6 | missing(mfn_rate)

    * Ensure consistent format
    tostring hscode, replace force
    destring mfn_rate, replace force

    * Append to master
    append using `combined_tariffs'
    save `combined_tariffs', replace
}

* ---- Finalize Tariff Dataset with Sector Mapping ----

use `combined_tariffs', clear

* Convert HS6 and extract HS2
destring hscode, gen(hscode_num) force
drop hscode
rename hscode_num hscode
format hscode %06.0f
gen hs2 = floor(hscode / 10000)

* Create sector_group for goods-producing sectors
gen sector_group = .
replace sector_group = 1 if inrange(hs2, 1, 4)
replace sector_group = 2 if inrange(hs2, 5, 9) | inrange(hs2, 35, 44)
replace sector_group = 3 if inrange(hs2, 10, 12)
replace sector_group = 4 if inrange(hs2, 13, 15)
replace sector_group = 5 if inrange(hs2, 16, 18)
replace sector_group = 6 if inrange(hs2, 19, 25)
replace sector_group = 7 if inrange(hs2, 26, 30)
replace sector_group = 8 if inrange(hs2, 31, 33)

* Drop non-goods and missing
drop if missing(sector_group, mfn_rate, country)

* Label variables
label define sector_grp 1 "Agriculture" 2 "Non-mfg" 3 "Food/bev" 4 "Textiles" 5 "Wood" ///
                       6 "Fuel/chem/metal" 7 "Machinery/transport" 8 "Other mfg"
label values sector_group sector_grp

label variable hscode "HS 6-digit Product Code"
label variable mfn_rate "MFN Applied Tariff (%)"
label variable country "Country Code"

* Save cleaned master file
save "$data/WITS Data/south_asia_mfn_tariffs.dta", replace
export delimited using "$data/WITS Data/south_asia_mfn_tariffs.csv", replace

* ---- Collapse and Graph ----

collapse (mean) mfn_rate, by(country sector_group)
save "$output/mfn_tariffs_by_country_sector.dta", replace

export delimited using "$output/mfn_tariffs_by_country_sector.csv", replace

graph bar mfn_rate, ///
    over(sector_group, label(angle(45))) ///
    by(country, title("MFN Tariffs by Sector Across South Asia") ///
        note("Source: WITS, latest year available", size(small)) ///
        row(2) compact) ///
    ytitle("Avg. MFN Tariff (%)") ///
    bar(1, color(blue)) ///
    blabel(bar, format(%4.1f) position(outside)) ///
    legend(off)


graph export "$figs/mfn_tariffs_faceted_by_country.png", replace


//END

* =====================================================

* =====================================================