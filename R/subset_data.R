
#' @param infile input file path, ftp or local
#' @param region chromosomal region of interest, string in format "chr:start-end"
#' @param outfile output file path
#' @examples
#' subset_data_file(infile = "extdata/I9_VARICVE_chr1.tsv.gz", region = "1:10565520-10965520", outfile = "delete_me_gwas.txt")
#' subset_data_file(infile = "ftp://ftp.ebi.ac.uk/pub/databases/spot/eQTL/csv/Alasoo_2018/ge/Alasoo_2018_ge_macrophage_IFNg.all.tsv.gz", region = "1:10565520-10965520", outfile = "delete_me_eqtl.txt")

subset_data_file <- function(infile, region, outfile) {
  
    header <- try(system(paste("tabix ", infile, region, " -H"), intern = TRUE))

    if (length(header) == 0) { ## try with curl
        header <- try(system(paste("curl -s ", infile, "| zcat | head -n 1"), intern = TRUE), silent = FALSE)

        if (length(header) == 0) { ## if curl doesn't work, try with zcat
            header <- system(paste("zcat ", infile, "| head -n 1"), intern = TRUE)
        }

        system(paste("tabix", infile, region, ">", paste0(outfile, "_tmp"))) # reads the file and filters to the region, system() function input is command line command 

        system(paste(paste0("echo '", header, "'> "), outfile, " && cat", paste0(outfile, "_tmp"), " >> ", outfile))
        
        system(paste("rm", paste0(outfile, "_tmp")))


    } else {

        system(paste("tabix ", infile, region, " -h >", paste0(outfile))) # reads the file and filters to the region, system() function input is command line command 

    }

    cat("File written to:", outfile, "\n")


}
