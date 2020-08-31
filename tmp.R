
## PARAMETERS ///////////
DIR <- "/COLOC/extdata/"
dir_eqtl <- paste0(DIR, "Lepik_2017_ge_blood_chr1_ENSG00000130940.all.tsv" )
dir_gwas <- paste0(DIR, "I9_VARICVE_chr1.tsv" )
header_gwas <- c("varid" = "rsids", "pval" = "pval", "maf" = "maf", "beta"= "beta", "se"= "sebeta")
header_eqtl <- c("varid" = "rsid", "pval" = "pvalue", "maf" = "maf", "beta" = "beta", "gene_id" = "gene_id")
out <- "/data/output/tmp/"
n_gwas <- 11006	+ 117692
n_eqtl <- 491
p1 <- 1e-04 
p2 <- 1e-04 
p12 <- 1e-06
## //////////////////////

library(data.table)
library(coloc)
library(locuscomparer)

## outname -------------------
bits <- sapply(c(dir_gwas, dir_eqtl), function(x) unlist(strsplit(basename(x), "\\."))[1])
outname <- paste0(out, paste(bits, collapse = "-"))

## read data -----------------

df_eqtl <- data.table::fread(file = dir_eqtl, select = unname(header_eqtl))
names(df_eqtl) <- names(header_eqtl)
df_gwas <- data.table::fread(file = dir_gwas, select= unname(header_gwas))
names(df_gwas) <- names(header_gwas)

## create se if not available -------
## super dodgy
df_eqtl$se <- abs(df_eqtl$beta / qnorm(df_eqtl$pval/2, lower.tail = FALSE))

## clean ------------------------
df_gwas <- na.omit(df_gwas)
df_eqtl <- na.omit(df_eqtl)

## join -------------------------
input <- merge(df_gwas, df_eqtl, by = "varid", suffixes = c("_gwas", "_eqtl"), all = FALSE)

dataset_gwas <- list(
    beta = input$beta_gwas,
    varbeta = input$se_gwas^2,
 #   pvalues = input$pval_gwas, 
    MAF = input$maf_gwas,
    type = "cc", 
    s = 11006/117692, 
  #  sdY = 1,
    snp = input$varid,
    N = n_gwas)

dataset_eqtl <- list(
    beta = input$beta_eqtl,
    varbeta = input$se_eqtl^2,
  #  pvalues = input$pval_eqtl, 
    MAF = input$maf_eqtl,
    type = "quant", 
    sdY = 1,
    snp = input$varid,
    N = n_eqtl)

## sensitivity --------------------------
my.res <- coloc.abf(dataset1=dataset_gwas, dataset2=dataset_eqtl)

## coloc --------------------------
result <- coloc::coloc.signals(
    dataset1 = dataset_gwas, 
    dataset2 = dataset_eqtl,
    MAF = input$maf_eqtl, 
    p12 = p12, 
    p1 = p1, 
    p2 = p2, 
  #  r2thr=0.00001, 
 #   pthr = 1e-1,
    method = "mask"
     )


finemap.signals(dataset_gwas,method="mask")
finemap.signals(dataset_eqtl,method="mask")

data.table::fwrite(result, file = paste0(outname, ".tsv"), sep = "\t")

## locuscompare -----------------

pdf(paste0(outname, ".pdf"))
locuscomparer::locuscompare(
    in_fn1 = dir_gwas, in_fn2 = dir_eqtl, 
    title1 = "GWAS", title2 = "eQTL", 
    marker_col1 = header_gwas["varid"], pval_col1 = header_gwas["pval"], 
    marker_col2 = header_eqtl["varid"], pval_col2 = header_eqtl["pval"], 
    genome = "hg38", snp = "rs11121615")
dev.off()
