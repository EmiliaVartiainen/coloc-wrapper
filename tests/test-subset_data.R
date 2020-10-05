library(testthat)
source("R/subset_data.R")

test_that("file with header", {
  subset_data_file(infile = "extdata/I9_VARICVE_chr1.tsv.gz", region = "1:10565520-10965520", outfile = "file_with_header.txt")
  dat <- data.table::fread("file_with_header.txt")
  file.remove("file_with_header.txt")
  expect_reference(object = dat, file = "tests/rds/file_with_header.rds")
})

test_that("file without header", {
  expect_equal(2 * 2, 4)
  ## tbd
})


test_that("ftp without header", {
  subset_data_file(infile = "extdata/I9_VARICVE_chr1.tsv.gz", region = "1:10565520-10965520", outfile = "file_with_header.txt")
  dat <- data.table::fread("file_with_header.txt")
  file.remove("file_with_header.txt")
  expect_reference(object = dat, file = "tests/rds/file_with_header.rds")
})

subset_data_file(infile = "ftp://ftp.ebi.ac.uk/pub/databases/spot/eQTL/csv/Alasoo_2018/ge/Alasoo_2018_ge_macrophage_IFNg.all.tsv.gz", region = "1:10565520-10965520", outfile = "delete_me_eqtl.txt")

