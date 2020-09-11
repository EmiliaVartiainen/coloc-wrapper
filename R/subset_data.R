

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

subset_data_file <- function(infile, region, outfile) {
    cat(outfile, "\n")
    system(paste("tabix", "-h", infile, region, ">", outfile)) # reads the file and filters to the region, system() function input is command line command 
}


