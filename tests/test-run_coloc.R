library(testthat)
source("R/run_coloc.R")

test_that("Coloc for region on chr 1 between Lepik blood and FG I9_VARICVE for gene ENSG00000130940", {
  reference <- readRDS("tests/rds/lepik_I9_VARICVE_chr1_ENSG00000130940.rds")

  dat_single <- run_coloc(eqtl_data = "extdata/Lepik_2017_ge_blood_chr1_ENSG00000130940.all.tsv", gwas_data = "extdata/I9_VARICVE_chr1.tsv.gz", return_object = TRUE)
  expect_equal(dat_single, reference)

  dat <- run_coloc(eqtl_data = "extdata/Lepik_2017_ge_blood_chr1_ENSG00000142655_ENSG00000130940.all.tsv", gwas_data = "extdata/I9_VARICVE_chr1.tsv.gz", return_object = TRUE)
  expect_equal(droplevelsdat[dat$gene == "ENSG00000130940"]), reference)

})


test_that("Coloc for region on chr 1 between Lepik blood and FG I9_VARICVE for gene ENSG00000142655", {
  reference <- readRDS("tests/rds/lepik_I9_VARICVE_chr1_ENSG00000142655.rds")
  
  dat_single <- run_coloc(eqtl_data = "extdata/Lepik_2017_ge_blood_chr1_ENSG00000142655.all.tsv", gwas_data = "extdata/I9_VARICVE_chr1.tsv.gz", return_object = TRUE)
  expect_equal(dat_single, reference)

  dat <- run_coloc(eqtl_data = "extdata/Lepik_2017_ge_blood_chr1_ENSG00000142655_ENSG00000130940.all.tsv", gwas_data = "extdata/I9_VARICVE_chr1.tsv.gz", return_object = TRUE)
  expect_equal(droplevels(dat[dat$gene == "ENSG00000142655",]), reference)

})