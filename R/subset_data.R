
#' @param infile input file path, ftp or local
#' @param region chromosomal region of interest, "chr:start-end"
#' @param outfile output file path
#' @examples
#' subset_data_file(infile = "/Users/eahvarti/Documents/coloc_analysis/Data/finngen_R5_I9_VARICVE.gz", region = "1:10565520-10965520", outfile = "/Users/eahvarti/Downloads/delete_me.txt")
#' subset_data_file(infile = "/data/output/tmp/finngen_R5_O15_ICP.gz", region = "1:10565520-10965520", outfile = "/data/output/delete_me.txt")
#' subset_data_file(infile = "ftp://ftp.ebi.ac.uk/pub/databases/spot/eQTL/csv/Alasoo_2018/ge/Alasoo_2018_ge_macrophage_IFNg.all.tsv.gz", region = "1:10565520-10965520", outfile = "delete_me.txt", header = "FID\tIID\tPAT\tMAT\tSEX\tPHENOTYPE")

subset_data_file <- function(infile, region, outfile, header = NULL) {
    cat(outfile, "\n")
  
    if (!is.null(header)) {

       # system(paste("cat ", infile, "| head -n 1 >", paste0(outfile, "_tmp"))) # reads the file and filters to the region, system() function input is command line command 
       # system(paste("tabix", infile, region, ">", paste0(outfile))) # reads the file and filters to the region, system() function input is command line command 

       # system("echo -e ", header, "> ", paste0(outfile, "_tmp"). " && cat", paste0(outfile), " >> ", paste0(outfile, "_tmp") && rm paste0(outfile, "_tmp")

    } else {
        system(paste("tabix ", infile, region, " -h >", paste0(outfile))) # reads the file and filters to the region, system() function input is command line command 

    }

}
