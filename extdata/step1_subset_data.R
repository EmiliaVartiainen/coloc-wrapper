## todo
## - with varids, instead of rsids

suppressMessages(library(optparse))
suppressMessages(library(data.table))

option_list <- list(
    optparse::make_option(c("--eqtl"), type="character", default= "/COLOC/extdata/Lepik_2017_ge_blood_chr1_ENSG00000130940.all.tsv",help="eQTL summary stats for one region"),
    optparse::make_option(c("--gwas"), type="character", default="/COLOC/extdata/I9_VARICVE_chr1.tsv", help = "GWAS summary stats for 1 region") ,
    optparse::make_option(c("--out"), type="character", default="/COLOC/out.txt", help = "outputfile") 
)


subset_data()
