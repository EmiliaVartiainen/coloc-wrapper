#!/usr/bin/env Rscript

req_packages <- c("BiocManager", "devtools", "dplyr", "coloc","optparse","data.table","R.utils", "testthat")
for (pack in req_packages) {
    if(pack != "data.table" & !require(pack, character.only = TRUE)) {
        install.packages(pack, repos = "http://cran.us.r-project.org")
    }
    if(pack == "data.table" & !require(pack, character.only = TRUE)) {
        ## sad solution for data.table
        install.packages("data.table", type = "source",repo="http://Rdatatable.github.io/data.table")
    }
}

## snpStats
BiocManager::install("snpStats")

## locuscomparer
remotes::install_github("boxiangliu/locuscomparer")
remotes::install_github("chr1swallace/coloc")
