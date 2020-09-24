
## todo
## - with varids, instead of rsids

run_coloc <- function(eqtl_data, gwas_data, out) {
    n_gwas <- 11006	+ 117692
    n_eqtl <- 491
    DIR <- "/COLOC/extdata/"
    dir_eqtl <- paste0(DIR, "Lepik_2017_ge_blood_chr1_ENSG00000130940.all.tsv" )
    dir_gwas <- paste0(DIR, "I9_VARICVE_chr1.tsv" )
    header_gwas <- c("varid" = "rsids", "pval" = "pval", "maf" = "maf", "beta"= "beta", "se"= "sebeta")
    header_eqtl <- c("varid" = "rsid", "pval" = "pvalue", "maf" = "maf", "beta" = "beta", "gene_id" = "gene_id")

    #header_gwas <- c("varid" = "rsids", "pval" = "pval", "maf" = "maf")
    #header_eqtl <- c("varid" = "rsid", "pval" = "pvalue", "maf" = "maf")

    ## outname -------------------
    #bits <- sapply(c(gwas_data, eqtl_data), function(x) unlist(strsplit(basename(x), "\\."))[1])
    #outname <- paste0(opt$out, paste(bits, collapse = "-"))

    ## read data -----------------

    df_eqtl <- data.table::fread(file = eqtl_data) #select = unname(header_eqtl))
    #names(df_eqtl) <- names(header_eqtl)
    df_gwas <- data.table::fread(file = gwas_data) #select= unname(header_gwas))
    #names(df_gwas) <- names(header_gwas)

    ## select ------------------------
    df_gwas <- df_gwas[,c("rsids", "pval", "maf")]
    df_eqtl <- df_eqtl[,c("rsid", "pvalue", "maf")]
    
    ## join -------------------------
    df <- dplyr::inner_join(df_gwas, df_eqtl, by = c("rsids" = "rsid"))
    #print(head(df))
    

    ## create data lists ------------
    dataset_gwas <- list(
        pvalues = df$pval, 
        MAF = df$maf.x,
        type = "cc", 
        s = 11006/117692, 
        #  sdY = 1,
        snp = df$rsids,
        N = n_gwas)
    
    dataset_eqtl <- list(
        pvalues = df$pvalue, 
        MAF = df$maf.y,
        type = "quant", 
        sdY = 1,
        snp = df$rsid,
        N = n_eqtl)
    
    ## run coloc.abf() --------------------------
    my.res <- coloc::coloc.abf(dataset1=dataset_gwas, dataset2=dataset_eqtl, p1 = 1e-4, p2 = 1e-4, p12 = 1e-5)
    data.table::fwrite(data.frame(t(my.res$summary)), file = out, sep = "\t")
    
    ## run locuscompare -------------
    pdf(paste0(out, ".pdf"))
    locuscomparer::locuscompare(
        in_fn1 = dir_gwas, in_fn2 = dir_eqtl, 
        title1 = "GWAS", title2 = "eQTL", 
        marker_col1 = header_gwas["varid"], pval_col1 = header_gwas["pval"], 
        marker_col2 = header_eqtl["varid"], pval_col2 = header_eqtl["pval"], 
        genome = "hg38", snp = "rs11121615")
    dev.off()
}

run_coloc(eqtl_data = "extdata/Lepik_2017_ge_blood_chr1_ENSG00000130940.all.tsv", gwas_data = "extdata/I9_VARICVE_chr1.tsv.gz", out = "test1.txt")
