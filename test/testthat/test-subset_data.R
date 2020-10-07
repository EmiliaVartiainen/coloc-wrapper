
test_that("ftp without header", {

  reference <- readRDS("../rds/ftp_without_header.rds")

  subset_data_file(infile = "ftp://ftp.ebi.ac.uk/pub/databases/spot/eQTL/csv/Alasoo_2018/ge/Alasoo_2018_ge_macrophage_IFNg.all.tsv.gz", region = "1:10565520-10965520", outfile = "ftp_without_header.txt")
  dat <- read.table("ftp_without_header.txt", sep = "\t", header = TRUE)
  file.remove("ftp_without_header.txt")

  expect_equal(dat, reference)

  ## withr::defer(unlink("mtcars.csv"), teardown_env())
})

test_that("file with header", {

  reference <- readRDS("../rds/file_with_header.rds")

  subset_data_file(infile = "../../extdata/I9_VARICVE_chr1.tsv.gz", region = "1:10565520-10965520", outfile = "file_with_header.txt")
  dat <- read.table("file_with_header.txt", sep = "\t", header = TRUE)
  file.remove("file_with_header.txt")

  expect_equal(dat, reference)
})

