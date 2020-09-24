
#' @param infile input file path, ftp or local
#' @param region chromosomal region of interest, "chr:start-end"
#' @param outfile output file path
#' @examples
#' subset_data_file(infile = "/Users/eahvarti/Documents/coloc_analysis/Data/finngen_R5_I9_VARICVE.gz", region = "1:10565520-10965520", outfile = "/Users/eahvarti/Downloads/delete_me.txt")
#' subset_data_file(infile = "/COLOC/extdata/I9_VARICVE_chr1.tsv.gz", region = "1:10565520-10965520", outfile = "delete_me.txt")
#' subset_data_file(infile = "ftp://ftp.ebi.ac.uk/pub/databases/spot/eQTL/csv/Alasoo_2018/ge/Alasoo_2018_ge_macrophage_IFNg.all.tsv.gz", region = "1:10565520-10965520", outfile = "delete_me.txt")

subset_data_file <- function(infile, region, outfile) {

    cat(outfile, "\n")
  
    header <- try(system(paste("tabix ", infile, region, " -H"), intern = TRUE))

    if (length(header) == 0) {
        header <- system(paste("curl -s ", infile, "| zcat | head -n 1"), intern = TRUE)

        system(paste("tabix", infile, region, ">", paste0(outfile))) # reads the file and filters to the region, system() function input is command line command 

        system(paste(
            "echo -e ", header, "> ", paste0(outfile, "_tmp"), 
            " && cat", outfile, " >> ", paste0(outfile, "_tmp && rm "), paste0(outfile, "_tmp")
            ))

    } else {

        system(paste("tabix ", infile, region, " -h >", paste0(outfile))) # reads the file and filters to the region, system() function input is command line command 

    }


}
