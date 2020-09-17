
#' @param infile input file path, ftp or local
#' @param region chromosomal region of interest, "chr:start-end"
#' @param outfile output file path
#' @examples
#' subset_data_file(infile = "/Users/eahvarti/Documents/coloc_analysis/Data/finngen_R5_I9_VARICVE.gz", region = "1:10565520-10965520", outfile = "/Users/eahvarti/Downloads/delete_me.txt")

subset_data_file <- function(infile, region, outfile) {
  cat(outfile, "\n")
  system(paste("tabix", "-h", infile, region, ">", outfile)) # reads the file and filters to the region, system() function input is command line command 
  system(paste("tabix", infile, region, ">", paste0(outfile, "_tmp"))) 
  system(paste("zcat ", infile, "| head -n 1 >", paste0(outfile, "_header")))
  
  system(paste("cat ", paste0(outfile, "_header"), paste0(outfile, "_tmp"), " >", outfile)) 
  system(paste("rm", paste0(outfile, "_tmp")))
  system(paste("rm", paste0(outfile, "_header"))) 
  
}
