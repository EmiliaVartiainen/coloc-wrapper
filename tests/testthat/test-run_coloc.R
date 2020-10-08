
test_that("MAF + PVAL: Coloc for region on chr 1 between Lepik blood and FG I9_VARICVE for gene ENSG00000130940", {

  reference <- readRDS("../rds/lepik_I9_VARICVE_chr1_ENSG00000130940.rds")

  dat_single <- run_coloc(
    eqtl_data = "../../extdata/Lepik_2017_ge_blood_chr1_ENSG00000130940.all.tsv", 
    gwas_data = "../../extdata/I9_VARICVE_chr1.tsv.gz", 
    return_object = TRUE, return_file = FALSE,
    eqtl_info = list(type = "quant", sdY = 1, N = 491), 
    gwas_info = list(type = "cc", s = 11006/117692, N  = 11006	+ 117692), 
    gwas_header = c(varid = "rsids", pvalues = "pval", MAF = "maf"), 
    eqtl_header = c(varid = "rsid", pvalues = "pvalue", MAF = "maf", gene_id = "gene_id")
   )
  expect_equal(dat_single, reference)

  dat <- run_coloc(
    eqtl_data = "../../extdata/Lepik_2017_ge_blood_chr1_ENSG00000142655_ENSG00000130940.all.tsv", 
    gwas_data = "../../extdata/I9_VARICVE_chr1.tsv.gz", 
    return_object = TRUE, return_file = FALSE,
    eqtl_info = list(type = "quant", sdY = 1, N = 491), 
    gwas_info = list(type = "cc", s = 11006/117692, N  = 11006	+ 117692), 
    gwas_header = c(varid = "rsids", pvalues = "pval", MAF = "maf"), 
    eqtl_header = c(varid = "rsid", pvalues = "pvalue", MAF = "maf", gene_id = "gene_id")
   )
  expect_equal(data.frame(droplevels(dat[dat$gene == "ENSG00000130940",]), row.names = NULL), reference)

})

test_that("Locuscomparer for gene ENSG00000130940", {

  dat_single <- run_coloc(
    eqtl_data = "../../extdata/Lepik_2017_ge_blood_chr1_ENSG00000130940.all.tsv", 
    gwas_data = "../../extdata/I9_VARICVE_chr1.tsv.gz", 
    out = "tmp.txt", 
    return_object = FALSE, return_file = FALSE,
    eqtl_info = list(type = "quant", sdY = 1, N = 491), 
    gwas_info = list(type = "cc", s = 11006/117692, N  = 11006	+ 117692), 
    gwas_header = c(varid = "rsids", pvalues = "pval", MAF = "maf"), 
    eqtl_header = c(varid = "rsid", pvalues = "pvalue", MAF = "maf", gene_id = "gene_id"), 
    locuscompare_info = list(rsid_eqtl = "rsid", rsid_gwas = "rsids", pval_eqtl = "pvalue", pval_gwas = "pval", pop = "EUR")
   )

  expect_true(file.exists("tmp.png"))
  file.remove("tmp.png")

##    eqtl_data = "../../extdata/Lepik_2017_ge_blood_chr1_ENSG00000142655_ENSG00000130940.all.tsv", 
## check if 2 files are stored out

})




test_that("MAF + PVAL: Coloc for region on chr 1 between Lepik blood and FG I9_VARICVE for gene ENSG00000142655", {
  
  reference <- readRDS("../rds/lepik_I9_VARICVE_chr1_ENSG00000142655.rds")

  dat_single <- run_coloc(
    eqtl_data = "../../extdata/Lepik_2017_ge_blood_chr1_ENSG00000142655.all.tsv", 
    gwas_data = "../../extdata/I9_VARICVE_chr1.tsv.gz", 
    return_object = TRUE, return_file = FALSE,
    eqtl_info = list(type = "quant", sdY = 1, N = 491), 
    gwas_info = list(type = "cc", s = 11006/117692, N  = 11006	+ 117692), 
    gwas_header = c(varid = "rsids", pvalues = "pval", MAF = "maf"), 
    eqtl_header = c(varid = "rsid", pvalues = "pvalue", MAF = "maf", gene_id = "gene_id")
   )
  expect_equal(dat_single, reference)

  dat <- run_coloc(
    eqtl_data = "../../extdata/Lepik_2017_ge_blood_chr1_ENSG00000142655_ENSG00000130940.all.tsv", 
    gwas_data = "../../extdata/I9_VARICVE_chr1.tsv.gz",
    return_object = TRUE, return_file = FALSE,
    eqtl_info = list(type = "quant", sdY = 1, N = 491), 
    gwas_info = list(type = "cc", s = 11006/117692, N  = 11006	+ 117692), 
    gwas_header = c(varid = "rsids", pvalues = "pval", MAF = "maf"), 
    eqtl_header = c(varid = "rsid", pvalues = "pvalue", MAF = "maf", gene_id = "gene_id")
   )
  expect_equal(data.frame(droplevels(dat[dat$gene == "ENSG00000142655",]), row.names = NULL), reference)

})

##     gwas_header = c(varid = "rsids", MAF = "maf", beta = "beta", sebeta = "sebeta"),
