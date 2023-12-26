# Multispecies population-scale emergence of climate change signals in an ocean warming hotspot

### About:

This is the home of supporting data/code used in the creation of figures and supplements in "Multispecies population-scale emergence of climate change signals in an ocean warming hotspot", accepted for publication in ICES Journal of Marine Science.

This repository will be updated when the publication is publicly available.

### Repository Organization:

#### Data

The `Data` directory contains data access to summary results of our analyses.

Northeast US Trawl Survey data used for these analyses is publicly available and may be obtained directly from the National Marine Fisheries Service, Northeast Fisheries Science Center. For further inquiries please reach out or submit an issue via github.

Sea surface temperature data has not been included (for size reasons) and may be obtained from: 
\> <https://www.ncei.noaa.gov/products/optimum-interpolation-sst> 

#### R

The `R` directory contains the minimum code and documentation to recreate the figures and supplements included in this publication within two folders; `Analyses` and `Figures`.

##### Analyses

-   `distribution_significance_testing.R` performs a statistical t-test on species distributions pre- and post-2010. To complete this analyses, we selected season-strata of interest from the trawl survey data and calculated biomass-weighted averages of latitude, longitude, sea surface temperature, bottom temperature and depth for each species of interest. This cleaned data set is available in the data directory as `annual_averages.rds`.

-   (something about growth analyses here)

##### Figures

This folder contains the scripts to create the figures featured in the publication and supplemental materials, labeled by figure name.

### Funding

### Collaborators
