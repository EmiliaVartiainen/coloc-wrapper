## todo
## - with varids, instead of rsids

source("R/subset_data.R")
suppressMessages(library(optparse))

option_list <- list(
<<<<<<< HEAD
    optparse::make_option(c("--eqtl"), type="character", default= "/COLOC/extdata/Lepik_2017_ge_blood_chr1_ENSG00000130940.all.tsv",help="eQTL summary stats for one region"),
    optparse::make_option(c("--gwas"), type="character", default="/COLOC/extdata/I9_VARICVE_chr1.tsv", help = "GWAS summary stats for 1 region") ,
    optparse::make_option(c("--region"), type="character", default="chr:start-pos", help = "region") ,
    optparse::make_option(c("--out"), type="character", default="/COLOC/out.txt", help = "outputfile") 
)

opt <- optparse::parse_args(optparse::OptionParser(option_list=option_list))


subset_data(eqtl = opt$eqtl, gwas = opt$gwas, region = opt$region, out = opt$out)
=======
    optparse::make_option(c("--file"), type="character", default= "/COLOC/extdata/Lepik_2017_ge_blood_chr1_ENSG00000130940.all.tsv",help="eQTL summary stats for one region"),
    optparse::make_option(c("--region"), type="character", default="1:10565520-10965520", help="Genomic region of interest"), # Added this option -Emilia 
    optparse::make_option(c("--out"), type="character", default="/COLOC/out.txt", help="outputfile") 
)

opt <- optparse::parse_args(optparse::OptionParser(option_list=option_list))

subset_data_file(infile = opt$file, region = opt$region, outfile = opt$out)  














>>>>>>> 35f78b05a8e01f3ea28b37626c6efcfc41a5a8e7
