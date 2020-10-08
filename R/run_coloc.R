library(data.table)
library(locuscomparer)
library(coloc)

options(bitmapType='cairo')


## todos
## - tests for beta/sebeta
## - tests for locuscompare
## - warnings
##      - error out if header incomplete
## - finetune parameters
## - function coloc.abf correct?
## - locuszoomplot for genes

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
#' @param gwas_header vector containing headers of gwas_data, either c(varid, pvalues, MAF) or c(varid, beta, sebeta, maf).
#' @param eqtl_header vector containing headers of eqtl_data, either c(varid, gene_id, pvalues, MAF) or c(varid, gene_id, beta, sebeta, maf).
#' @param locuscompare_info NULL by default, otherwise list containing rsid_gwas, pval_gwas and rsid_eqtl, pval_eqtl
#' @details for input data and parameters see https://chr1swallace.github.io/coloc/
#' varid can be any variant identifier, but format needs to match between datasets. 
#' @examples
#' run_coloc(
#'    eqtl_data = "extdata/Lepik_2017_ge_blood_chr1_ENSG00000130940.all.tsv", 
#'    gwas_data = "extdata/I9_VARICVE_chr1.tsv.gz", 
#'    return_object = TRUE, return_file = FALSE,
#'    out = "tmp.txt", 
#'    eqtl_info = list(type = "quant", sdY = 1, N = 491), 
#'    gwas_info = list(type = "cc", s = 11006/117692, N  = 11006	+ 117692), 
#'    gwas_header = c(varid = "rsids", pvalues = "pval", MAF = "maf"), #, beta = "beta", se = "sebeta"),
#'    eqtl_header = c(varid = "rsid", pvalues = "pvalue", MAF = "maf", gene_id = "gene_id"), 
#'    locuscompare_info = list(rsid_eqtl = "rsid", rsid_gwas = "rsids", pval_eqtl = "pvalue", pval_gwas = "pval", pop = "EUR")
#'   )


run_coloc <- function(eqtl_data, gwas_data, out, p1 = 1e-4, p2 = 1e-4, p12 = 1e-5, 
    return_object = FALSE, return_file = TRUE, 
    eqtl_info = list(type = "quant", sdY = 1, N = NA), 
    gwas_info = list(type = "cc", s = NA, N = NA), 
    gwas_header = c(varid = "rsid", pvalues = "pval", MAF = "maf"),
    eqtl_header = c(varid = "rsid", pvalues = "pval", MAF = "maf", gene_id = "gene_id"),
    locuscompare_info =  NULL  ) {
    
    ## check if beta/se or pval/maf --------------------

    ## read data -----------------

    df_eqtl <- data.table::fread(file = eqtl_data, select = unname(eqtl_header))
    names(df_eqtl) <- paste0(names(eqtl_header), ".eqtl")
    df_gwas <- data.table::fread(file = gwas_data, select= unname(gwas_header))
    names(df_gwas) <- paste0(names(gwas_header), ".gwas")

    ## join -------------------------
    df <- dplyr::inner_join(df_gwas, df_eqtl, by = c("varid.gwas" = "varid.eqtl"))

    ## loop over genes -----------------
    genes <- unique(df$gene_id)
    my.res <- lapply(genes, function(x) {

                    df_sub <- df[which(df$gene_id == x),]

                    ## create gwas data lists ------------

                    dataset_gwas <- gwas_info
                    dataset_gwas$snp <- df_sub$varid.gwas

                    if ("pvalues" %in% names(gwas_header)) {
                        dataset_gwas$pvalues <- df_sub$pvalues.gwas
                    }

                    if ("MAF" %in% names(gwas_header)) {
                        dataset_gwas$MAF <- df_sub$MAF.gwas
                    }

                    if ("beta" %in% names(gwas_header)) {
                        dataset_gwas$beta <- df_sub$beta.gwas
                    }

                    if ("sebeta" %in% names(gwas_header)) {
                        dataset_gwas$varbeta <- df_sub$sebeta.gwas^2
                    }

                    ## create eqtl data lists ------------
                    
                    dataset_eqtl <- eqtl_info
                    dataset_eqtl$snp <- df_sub$varid.gwas

                    if ("pvalues" %in% names(eqtl_header)) {
                        dataset_eqtl$pvalues <- df_sub$pvalues.eqtl
                    }

                    if ("MAF" %in% names(eqtl_header)) {
                        dataset_eqtl$MAF <- df_sub$MAF.eqtl
                    }
                      
                    if ("beta" %in% names(eqtl_header)) {
                        dataset_eqtl$beta <- df_sub$beta.eqtl
                    }

                    if ("sebeta" %in% names(eqtl_header)) {
                        dataset_eqtl$varbeta <- df_sub$sebeta.eqtl^2
                    }



                    ## run coloc.abf() --------------------------
                    res <- coloc::coloc.abf(dataset1=dataset_gwas, dataset2=dataset_eqtl, 
                                            p1 = p1, p2 = p2, p12 = p12)
                    return (data.frame(gene = x, t(res$summary)))
    })

    ## combine results ------------------
    df <- do.call("rbind", my.res)

    
    ## run locuscompare -------------
    if (!is.null(locuscompare_info)) {
        # trim the outfile.txt -> outfile
        ## todo: needs to run for each gene
        filename <- paste0(sapply(strsplit(out, ".", fixed = TRUE), function(x) x[1]), ".png")
        png(filename, width = 1000, height = 600)
        qp <- locuscompare(
            in_fn1 = gwas_data, in_fn2 = eqtl_data, 
            title1 = "GWAS", title2 = "eQTL", 
            marker_col1 = locuscompare_info$rsid_gwas, pval_col1 = locuscompare_info$pval_gwas, 
            marker_col2 = locuscompare_info$rsid_eqtl, pval_col2 = locuscompare_info$pval_eqtl, 
            genome = "hg38", 
            population = locuscompare_info$pop) # , snp = "rs11121615"
        print(qp)
        dev.off()

    }


    ## return results --------------------

    if (return_file) {
        data.table::fwrite(df, file = out, sep = "\t")
    }
    
    if (return_object) {
        return(df)
    }

}

