
## todo
## - with varids, instead of rsids

run_coloc <- function(eqtl_data, gwas_data, out) {

    header_gwas <- c("varid" = "rsids", "pval" = "pval", "maf" = "maf")
    header_eqtl <- c("varid" = "rsid", "pval" = "pvalue", "maf" = "maf")


    ## outname -------------------
    bits <- sapply(c(gwas_data, eqtl_data), function(x) unlist(strsplit(basename(x), "\\."))[1])
    outname <- paste0(opt$out, paste(bits, collapse = "-"))

    ## read data -----------------

    df_eqtl <- data.table::fread(file = eqtl_data, select = unname(header_eqtl))
    names(df_eqtl) <- names(header_eqtl)
    df_gwas <- data.table::fread(file = gwas_data, select= unname(header_gwas))
    names(df_gwas) <- names(header_gwas)

    print(dim(df_gwas))
    print(dim(df_eqtl))
    print(head(outname))

    ## join -------------------------

    ## create data lists ------------

    ## run coloc.abf() --------------


    ## run locuscompare -------------


}
