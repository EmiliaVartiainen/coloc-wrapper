suppressMessages(library(optparse))

option_list <- list(
    optparse::make_option(c("--file"), type="character", default= "/COLOC/extdata/Lepik_2017_ge_blood_chr1_ENSG00000130940.all.tsv",help="eQTL or GWAS file path"),
    optparse::make_option(c("--region"), type="character", default="1:10565520-10965520", help="Genomic region of interest"), 
    optparse::make_option(c("--out"), type="character", default="/COLOC/out.txt", help="outputfile") 
)

opt <- optparse::parse_args(optparse::OptionParser(option_list=option_list))

source("R/subset_data.R")
subset_data_file(infile = opt$file, region = opt$region, outfile = opt$out)  










