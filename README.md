SPINS PLS Connectivity
===============================================

Empathic Accuracy (EA) task and resting state (RS) fMRI partial least squares correlation analyses using functional connectivity (FC) and social and non-social cognitive performance data.

Created by Lindsay Oliver lindsay.oliver@camh.ca 



Project Organization
-----------------------------------

    .
    ├── README.md          <- The top-level README
    ├── .gitignore         <- Files to not upload to github - data, reports
    ├── data
    │   ├── parcellations  <- Parcellations and associated information 
    │   ├── processed      <- Processed data
    │   └── raw            <- Original data
    │
    ├── notebooks          <- R notebooks for analysis workflow - should be run in order
    │
    ├── docs/references    <- Data dictionaries, manuals, and all other explanatory materials
    │
    ├── reports
    │   ├── figures        <- Generated graphics and figures
    │   ├── paper          <- Manuscript drafts and materials
    │   └── tables         <- Generated tables 
    │
    ├── code               <- Source code for use in this project (bash scripts)



Code
extract_time_series_EA_*mm_noGSR_glasser_tian.sh - scripts to extract time series data from the residual EA GLM outputs using the Glasser and Tian atlases with 2 or 6 mm smoothing and no GSR

extract_time_series_RS_2mm_noGSR_glasser_tian.sh - scripts to extract time series data from RS outputs using the Glasser and Tian atlases with 2 mm smoothing and no GSR


Notebooks
01_SPINS_data_cleaning.Rmd - data cleaning

02_EA_PLSC_subcor_combat_thresholded.Rmd - script for running PLSC on EA and cognitive data, including cortical and subcortical functional connectivity data harmonized using combat

02_RS_PLSC_subcor_combat_thresholded.Rmd - script for running PLSC on RS and cognitive data, including cortical and subcortical functional connectivity data harmonized using combat

03_EA_PLSC_subcor_combat_regresswFD_thresholded.Rmd - same as above for EA, but with regression of age, sex, and motion (mean FD) from FC and cog data before running PLSC

03_RS_PLSC_subcor_combat_regresswFD_thresholded.Rmd - same as above for RS, but with regression of age, sex, and motion (mean FD) from FC and cog data before running PLSC

EA_10FoldCV.R and RS_10FoldCV.R - cross-validation scripts


