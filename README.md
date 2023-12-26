# Multispecies population-scale emergence of climate change signals in an ocean warming hotspot

### About:

This is the home of supporting data/code used in the creation of figures and supplements in "Multispecies population-scale emergence of climate change signals in an ocean warming hotspot", accepted for publication in ICES Journal of Marine Science.

This repository will be updated when the publication is publicly available.

### Repository Organization:

#### Data

The `Data` directory contains data access to summary results of our analyses.

Northeast US Trawl Survey data used for these analyses is publicly available and may be obtained directly from the National Marine Fisheries Service, Northeast Fisheries Science Center. For further inquiries please reach out or submit an issue via github.

Sea surface temperature data has not been included (for size reasons) and may be obtained from:    
> <https://www.ncei.noaa.gov/products/optimum-interpolation-sst> 

#### R

The `R` directory contains the minimum code and documentation to recreate the figures and supplements included in this publication within two folders; `Analyses` and `Figures`.

##### Analyses

 -   `distribution_significance_testing.R` performs a statistical t-test on species distributions pre- and post-2010. To complete this analyses, we selected season-strata of interest from the trawl survey data and calculated biomass-weighted averages of latitude, longitude, sea surface temperature, bottom temperature and depth for each species of interest. This cleaned data set is available in the data directory as `annual_averages.rds`.
 
 -   `Area_Stratified_Abundance_Timeseries.R` Performs area-stratification adjustments to estimate the long-term population trends for each species. Abundance data comes from the Northeast trawl survey, run by NOAA/NMFS. Abundance is weighted by sampling effort and relative areas of the survey strata. Trawl survey data is available by request through the Northeast Fisheries Science Center (NEFSC). This script documents the processing steps for producing Figure S15.

 - `Size_at_Age_Analyses.R` Length and Weight at-age estimates derived for 14 species. . Data for these figures is the biological sub-sampling data collected as part of the Northeast trawl survey, run by NOAA/NMFS. This dataset contains more detailed information on individuals sampled in the survey such as age information. Trawl survey data is available by request through the Northeast Fisheries Science Center (NEFSC). This script documents the analysis and data preparation steps for Figures: 5, S8, S9, S10, S11, & S12.
 
  - `Northeast_US_and_GOM_SST.R` Sea surface temperature timeseries and maps for the Northeast US and the Gulf of Maine. NOAA OI SST V2 High Resolution Dataset data provided by the NOAA PSL, Boulder, Colorado, USA, from their website at https://psl.noaa.gov. This script provides mapping and plotting code for Figures: 2 & S1. For documentation on how the OISST data is cropped for each area please see: https://github.com/adamkemberling/oisst_mainstays


##### Figures

This folder contains the scripts to create the figures featured in the publication and supplemental materials, labeled by figure name.



### Funding

### Collaborators
