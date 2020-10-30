library(data.table)
library(ggplot2)
library(coloc)

options(bitmapType='cairo')

# # to test locuscompare, remove this 

# run_coloc(eqtl_data = "/Users/eahvarti/Documents/R_studio/Coloc_analysis/extdata/Lepik_2017_ge_blood_chr1_ENSG00000130940.all.tsv", 
#           gwas_data = "/Users/eahvarti/Documents/R_studio/Coloc_analysis/extdata/I9_VARICVE_chr1.tsv.gz", 
#           return_object = TRUE, return_file = FALSE, out = "coloc_test.txt", 
#           eqtl_info = list(type = "quant", sdY = 1, N = 491), 
#           gwas_info = list(type = "cc", s = 11006/117692, N  = 11006+117692), 
#           gwas_header = c(varid = "rsids", pvalues = "pval", MAF = "maf",  beta = "beta", se = "sebeta"), 
#           eqtl_header = c(varid = "rsid", pvalues = "pvalue", MAF = "maf", gene_id = "gene_id"), locuscompare_thresh = 0)


#' plots the locus and saves it in a file
#' @param df a data frame of one gene, contains both GWAS and eQTL data for it 
#' @param gene the name of the gene
#' @param filename the name of the output file 

locuscompare <- function(df, gene, filename) {
    filename <- sapply(strsplit(filename, ".", fixed = TRUE), function(x) x[1])

    if (!(any(names(df) %in% "pvalues.gwas"))) {
        stop("GWAS pvalue column is needed for the locuscompare plot, but missing from the data.")
    }

    if (!(any(names(df) %in% "pvalues.eqtl"))) {
        stop("eQTL pvalue column is needed for the locuscompare plot, but missing from the data.")
    }

    if (max(-log10(df$pvalues.gwas)) < max(-log10(df$pvalues.eqtl))) { # ratio for the plot coordinates 
        ratio <- (max(-log10(df$pvalues.eqtl))) / (max(-log10(df$pvalues.gwas)))
    }
    else {
        ratio <- (max(-log10(df$pvalues.gwas))) / (max(-log10(df$pvalues.eqtl)))
    }
    plot <- ggplot2::ggplot(data = df, aes(x = -log10(pvalues.gwas), y = -log10(pvalues.eqtl))) + geom_point(size = 0.6) + geom_abline(color = "black", linetype = 3) + 
        geom_smooth(method = "lm", se = FALSE, color = "black", size = 0.5) + theme_light() + coord_fixed(ratio = ratio) +
        labs(title = paste0(filename, " - ", gene), x = "GWAS -log10(P)", y = "eQTL -log10(P)") + 
        theme(axis.text.x = element_text(size = 7), axis.text.y = element_text(size = 7), axis.text = element_text(size = 7), plot.title = element_text(size = 12))
    
    ggplot2::ggsave(filename = paste0(filename, "_locuscompare_", gene, ".png"), plot = plot, width = 15, height = 15, units = "cm")
    print(plot)
}


## todos
## - tests 
##      - for beta/sebeta
##      - for locuscompare
## - warnings
##      - error out if header incomplete
## - finetune parameters
## - function coloc.abf correct?
## - locuscompare for each genes

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
#' @param locuscompare_thresh PP4 values between 0 and 1, anything above threshold will be plotted.
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
#'    locuscompare_thresh = 0,
#'   )


run_coloc <- function(eqtl_data, gwas_data, out = NULL, p1 = 1e-4, p2 = 1e-4, p12 = 1e-5, 
    return_object = FALSE, return_file = TRUE, 
    eqtl_info = list(type = "quant", sdY = 1, N = NA), 
    gwas_info = list(type = "cc", s = NA, N = NA), 
    gwas_header = c(varid = "rsids", pvalues = "pval", MAF = "maf"),
    eqtl_header = c(varid = "rsid", pvalues = "pvalue", MAF = "maf", gene_id = "gene_id"),
    locuscompare_thresh =  1) {
    
    ## check if beta/se or pval/maf --------------------

    ## read data -----------------

    df_eqtl <- data.table::fread(file = eqtl_data, select = unname(eqtl_header))
    names(df_eqtl) <- paste0(names(eqtl_header), ".eqtl")
    df_gwas <- data.table::fread(file = gwas_data, select= unname(gwas_header))
    names(df_gwas) <- paste0(names(gwas_header), ".gwas")

    ## ensure distinct values ---------
    df_eqtl <- unique(df_eqtl)

    df_gwas <- unique(df_gwas)

    ## join -------------------------
    df <- dplyr::inner_join(df_gwas, df_eqtl, by = c("varid.gwas" = "varid.eqtl"))

    ## loop over genes -----------------
    genes <- unique(df$gene_id)
    my.res <- lapply(genes, function(x) {
                    print(x)

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
                    res <- as.data.frame(t(res$summary))
                    
                    print(res)
                    
                    if (res$PP.H4.abf > locuscompare_thresh) {
                        locuscompare(df = df_sub, gene = x, filename = out)
                    }
                    
                 
                    return (data.frame(gene = x, res))
    })

    ## combine results ------------------
    results <- do.call("rbind", my.res)

    ## return results --------------------
    if (return_file) {
        data.table::fwrite(results, file = out, sep = "\t")
    }
    
    if (return_object) {
        return(results)
    }
}
