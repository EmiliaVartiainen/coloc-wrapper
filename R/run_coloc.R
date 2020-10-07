
## todo
## - with varids, instead of rsids
## - z/maf vs beta/se
## - headers

#' @param eqtl_data input file path, ftp or local
#' @param gwas_data chromosomal region of interest, string in format "chr:start-end"
#' @param out if return_object = FALSE, give filename
#' @param p1 see COLOC tool https://github.com/chr1swallace/coloc
#' @param p2 see COLOC tool https://github.com/chr1swallace/coloc
#' @param p12 see COLOC tool https://github.com/chr1swallace/coloc
#' @param return_object logical, return object
#' @param return_file logical, write out file
#' @param eqtl_info list containing type, N and depending on type sdY or s.
#' @param gwas_info list containing type, N and depending on type sdY (if type = quant) or s (if type = cc).

#' @details for input data and parameters see https://chr1swallace.github.io/coloc/
#' @examples
#' run_coloc(eqtl_data = "extdata/Lepik_2017_ge_blood_chr1_ENSG00000130940.all.tsv", gwas_data = "extdata/I9_VARICVE_chr1.tsv.gz", return_object = TRUE)

run_coloc <- function(eqtl_data, gwas_data, out, p1 = 1e-4, p2 = 1e-4, p12 = 1e-5, 
    return_object = FALSE, return_file = TRUE, eqtl_info = list(type = "quant", sdY = 1, N = 491), 
    gwas_info = list(type = "cc", s = 11006/117692, N  = 11006	+ 117692)
    ) {
    

    header_gwas <- c("varid" = "rsids", "pval" = "pval", "maf" = "maf", "beta"= "beta", "se"= "sebeta")
    header_eqtl <- c("varid" = "rsid", "pval" = "pvalue", "maf" = "maf", "beta" = "beta", "gene_id" = "gene_id")

    #header_gwas <- c("varid" = "rsids", "pval" = "pval", "maf" = "maf")
    #header_eqtl <- c("varid" = "rsid", "pval" = "pvalue", "maf" = "maf")

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
    
    ## loop over genes -----------------
    genes <- unique(df$gene_id)
    my.res <- lapply(genes, function(x) {
                    df_sub <- df[which(df$gene_id == x),]
                    
                    ## create data lists ------------
                    dataset_gwas <- gwas_info
                    dataset_gwas$pvalues <- df_sub$pval
                    dataset_gwas$MAF <- df_sub$maf.x
                    dataset_gwas$snp <- df_sub$rsids
                    
                    dataset_eqtl <- eqtl_info
                    dataset_eqtl$pvalues <- df_sub$pvalue
                    dataset_eqtl$MAF <- df_sub$maf.y
                    dataset_eqtl$snp <- df_sub$rsid
                    
                    ## run coloc.abf() --------------------------
                    res <- coloc::coloc.abf(dataset1=dataset_gwas, dataset2=dataset_eqtl, 
                                            p1 = p1, p2 = p2, p12 = p12)
                    return (data.frame(gene = x, t(res$summary)))
    })

    ## combine results ------------------
    df <- do.call("rbind", my.res)

    ## return results --------------------
    if (return_object) {
        return(df)
    }
    if (return_file) {
        data.table::fwrite(df, file = out, sep = "\t")
    }
    
    ## run locuscompare -------------
    #pdf(paste0(sapply(strsplit(out, ".", fixed = TRUE), function(x) x[1]), ".pdf")) # trims the outfile.txt -> outfile
    #locuscomparer::locuscompare(
    #    in_fn1 = gwas_data, in_fn2 = eqtl_data, 
    #    title1 = "GWAS", title2 = "eQTL", 
    #    marker_col1 = "rsids", pval_col1 = "pval", 
    #    marker_col2 = "rsid", pval_col2 = "pvalue", 
    #    genome = "hg38") # , snp = "rs11121615"
    #dev.off()

}

