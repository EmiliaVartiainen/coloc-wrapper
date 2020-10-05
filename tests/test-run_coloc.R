source("R/run_coloc.R")

test_that("multiplication works", {
  run_coloc(eqtl_data = "extdata/Lepik_2017_ge_blood_chr1_ENSG00000130940.all.tsv", gwas_data = "extdata/I9_VARICVE_chr1.tsv.gz",  out = "extdata/file.txt")
  test <- data.table::fread extdata/file.txt
  truth <- 
  expect_equal(test, truth)
})

test_that("multiplication works", {
  run_coloc(eqtl_data = "extdata/Lepik_2017_ge_blood_chr1_ENSG00000130940.all.tsv", gwas_data = "extdata/I9_VARICVE_chr1.tsv.gz",  out = "extdata/file.txt")
  test <- data.table::fread extdata/file.txt
  truth <- 
    expect_equal(test, truth)
})

