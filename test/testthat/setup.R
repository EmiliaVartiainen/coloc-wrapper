# Run before any test
library(testthat)
write.csv(iris, file = "mtcars.csv")
source("../../R/subset_data.R")
source("../../R/run_coloc.R")


# Run after all tests
