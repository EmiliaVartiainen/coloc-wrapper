
## todo
## - with varids, instead of rsids

## run_coloc(eqtl_data = "/COLOC/extdata/Lepik_2017_ge_blood_chr1_ENSG00000130940.all.tsv", gwas_data = "/COLOC/extdata/I9_VARICVE_chr1.tsv.gz",  out = "/COLOC/extdata/file.txt")
## run_coloc(eqtl_data = "extdata/Lepik_2017_ge_blood_chr1_ENSG00000142655_ENSG00000130940.all.tsv", gwas_data = "extdata/I9_VARICVE_chr1.tsv.gz", out = "test1.txt")


run_coloc <- function(eqtl_data, gwas_data, out, p1 = 1e-4, p2 = 1e-4, p12 = 1e-5) {
    n_gwas <- 11006	+ 117692
    n_eqtl <- 491

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
    df_eqtl <- df_eqtl[,c("rsid", "pvalue", "maf", "gene_id")]
    
    ## join -------------------------
    df <- dplyr::inner_join(df_gwas, df_eqtl, by = c("rsids" = "rsid"))
    #print(head(df))
    
    genes <- unique(df$gene_id)
    
    
    my.res <- lapply(genes, function(x) {
                    df_sub <- df[which(df$gene_id == x),]
                    
                    ## create data lists ------------
                    dataset_gwas <- list(
                        pvalues = df_sub$pval, 
                        MAF = df_sub$maf.x,
                        type = "cc", 
                        s = 11006/117692, 
                        #  sdY = 1,
                        snp = df_sub$rsids,
                        N = n_gwas)
                    
                    dataset_eqtl <- list(
                        pvalues = df_sub$pvalue, 
                        MAF = df_sub$maf.y,
                        type = "quant", 
                        sdY = 1,
                        snp = df_sub$rsid,
                        N = n_eqtl)
                    
                    ## run coloc.abf() --------------------------
                    res <- coloc::coloc.abf(dataset1=dataset_gwas, dataset2=dataset_eqtl, 
                                            p1 = p1, p2 = p2, p12 = p12)
                    return (data.frame(gene = x, t(res$summary)))
    })

    df <- do.call("rbind", my.res)
    print(df)
    data.table::fwrite(df, file = out, sep = "\t")
    
    ## run locuscompare -------------
    #pdf(paste0(out, ".pdf"))
    ## only use basename
    #locuscomparer::locuscompare(
    #    in_fn1 = gwas_data, in_fn2 = eqtl_data, 
    #    title1 = "GWAS", title2 = "eQTL", 
    #    marker_col1 = "rsids", pval_col1 = "pval", 
    #    marker_col2 = "rsid", pval_col2 = "pvalue", 
    #    genome = "hg38") # , snp = "rs11121615"
    #dev.off()

}

