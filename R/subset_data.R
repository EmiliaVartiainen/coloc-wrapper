

#' Title
#'
#' @param infile 
#' @param region 
#' @param outfile 
#'
#' @return
#' @export
#'
#' @examples
#' subset_data_file(infile = "/Users/eahvarti/Documents/coloc_analysis/Data/finngen_R5_I9_VARICVE.gz", region = "1:10565520-10965520", outfile = "/Users/eahvarti/Downloads/delete_me.txt")
#' subset_data_file(infile = "ftp://ftp.ebi.ac.uk/pub/databases/spot/eQTL/csv/Alasoo_2018/ge/Alasoo_2018_ge_macrophage_IFNg.all.tsv.gz", region = "1:10565520-10965520", outfile = "delete_me.txt")

subset_data_file <- function(infile, region, outfile) {
    cat(outfile, "\n")
    system(paste("tabix", infile, region, ">", paste0(outfile, "_tmp"))) # reads the file and filters to the region, system() function input is command line command 
    system(paste("zcat ", infile, "| head -n 1 >", paste0(outfile, "_header"))) # reads the file and filters to the region, system() function input is command line command 

    system(paste("cat ", paste0(outfile, "_header"), paste0(outfile, "_tmp"), " >", outfile)) # reads the file and filters to the region, system() function input is command line command 
    system(paste("rm", paste0(outfile, "_tmp")))
    system(paste("rm", paste0(outfile, "_header"))) 

}


