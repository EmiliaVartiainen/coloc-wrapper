## todo
## - with varids, instead of rsids

suppressMessages(library(optparse))
suppressMessages(library(data.table))

option_list <- list(
    optparse::make_option(c("--eqtl"), type="character", default= "/COLOC/extdata/Lepik_2017_ge_blood_chr1_ENSG00000130940.all.tsv",help="eQTL summary stats for one region"),
    optparse::make_option(c("--gwas"), type="character", default="/COLOC/extdata/I9_VARICVE_chr1.tsv", help="GWAS summary stats for 1 region") ,
    optparse::make_option(c("--region"), type="character", default="1:10565520-10965520", help="Genomic region of interest"), # Added this option -Emilia 
    optparse::make_option(c("--out"), type="character", default="/COLOC/out.txt", help="outputfile") 
)

# Question: How do I use/refer to these options/parameters later in the code? -Emilia 

# A general function to quickly import tabix indexed tab-separated files into data_frame

scanTabixDataFrame <- function(tabix_file, param, ...){
  tabix_list = Rsamtools::scanTabix(tabix_file, param = param)
  df_list = lapply(tabix_list, function(x,...){
    if(length(x) > 0){
      if(length(x) == 1){
        #Hack to make sure that it also works for data frames with only one row
        #Adds an empty row and then removes it
        result = paste(paste(x, collapse = "\n"),"\n",sep = "")
        result = readr::read_delim(result, delim = "\t", ...)[1,]
      }else{
        result = paste(x, collapse = "\n")
        result = readr::read_delim(result, delim = "\t", ...)
      }
    } else{
      #Return NULL if the nothing is returned from tabix file
      result = NULL
    }
    return(result)
  }, ...)
  return(df_list)
}

import_eQTLCatalogue <- function(ftp_path, region, column_names){
  #Fetch summary statistics with Rsamtools
  summary_stats = suppressMessages(scanTabixDataFrame(ftp_path, region, col_names = column_names)[[1]])
  print(head(summary_stats))
  # Remove rsid duplicates and multi-allelic variant
  if (!is.null(summary_stats)){
    summary_stats = dplyr::select(summary_stats, -rsid) %>% 
      dplyr::distinct() %>% #rsid duplicates
      dplyr::mutate(id = paste(chromosome, position, sep = ":")) %>% 
      dplyr::group_by(id, molecular_trait_id) %>%  
      dplyr::mutate(row_count = n()) %>% dplyr::ungroup() %>% 
      dplyr::filter(row_count == 1) #Multialllics
    return(summary_stats)
  }
  else {
    return(NULL)
  }
}


subset_data(eqtl, gwas, region) {
  region <- "1:10565520-10965520" # Just to test 
  chr <- as.numeric(sapply(strsplit(region, ":", fixed = TRUE), function(x) x[1]))
  start <- as.numeric(sapply(strsplit(sapply(strsplit(region, ":", fixed = TRUE), function(x) x[2]), "-", fixed = TRUE), function(x) x[1]))
  end <- as.numeric(sapply(strsplit(sapply(strsplit(region, ":", fixed = TRUE), function(x) x[2]), "-", fixed = TRUE), function(x) x[2]))
  region_granges <- GenomicRanges::GRanges(seqnames = chr, ranges = IRanges::IRanges(start = start, end = end), strand = "*")  # define the genomic region, it has to be GRanges thing forRsamtools::scanTabix() 
  
  eqtl_region <- import_eQTLCatalogue(eqtl, region_granges, colnames(readr::read_tsv(eqtl, n_max = 1))) # read the eQTL file and filter to to the region
  
  if (!is.null(eqtl_region)) {
    gwas_region <- scanTabix(gwas, index = paste(eqtl, "tbi", sep = "."), param = region_granges) # read the GWAS file and filter to the region, hang on what is index parameter?
    gwas_region <- str_replace(gwas_region[[1]], "\t\t", "\tNA\t") # handle empty columns 
    gwas_region <- read.table(text = gwas_region, sep = "\t") # create a data frame
  }
}

# NOTES: -Emilia 
# The filtered files are then returned from the subset_data() function into the run_coloc() function. Is the run_coloc() function going to go then the data through gene by gene and 
# run coloc to the subset?












