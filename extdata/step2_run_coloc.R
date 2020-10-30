
suppressMessages(library(optparse))
source("R/run_coloc.R")


option_list <- list(
    optparse::make_option(c("--eqtl"), type="character", default= "extdata/Lepik_2017_ge_blood_chr1_ENSG00000130940.all.tsv",help="eQTL summary stats for one region"),
    optparse::make_option(c("--gwas"), type="character", default="extdata/I9_VARICVE_chr1.tsv", help="GWAS summary stats for 1 region") ,
    optparse::make_option(c("--out"), type="character", default="out.txt", help="outputfile"), 
    optparse::make_option(c("--p1"), type="double", default=1e-4, help="the prior probability that any random SNP in the region is associated with exactly trait 1"), 
    optparse::make_option(c("--p2"), type="double", default=1e-4, help="the prior probability that any random SNP in the region is associated with exactly trait 2"), 
    optparse::make_option(c("--p12"), type="double", default=1e-5, help="the prior probability that any random SNP in the region is associated with both traits"),
    optparse::make_option(c("--header_eqtl"), type="character", default="c(varid = 'rsids', pvalues = 'pval', MAF = 'maf')", help="Header of the eQTL file, named vector in quotes"),
    optparse::make_option(c("--header_gwas"), type="character", default="c(varid = 'rsids', pvalues = 'pval', MAF = 'maf')", help="Header of the GWAS file, named vector in quotes"),
    optparse::make_option(c("--info_gwas"), type="character", default="list(type = 'cc', s = 11006/117692, N  = 11006 + 117692)", help="Options for gwas datalist"),
    optparse::make_option(c("--info_eqtl"), type="character", default="list(type = 'quant', sdY = 1, N = 491)", help="Options for eqtl datalist"),    
    optparse::make_option(c("--locuscompare_thresh"), type="double", default="significant", help="Which genes to plot")  

)

opt <- optparse::parse_args(optparse::OptionParser(option_list=option_list))
header_eqtl <- eval(parse(text=opt$header_eqtl))
header_gwas <- eval(parse(text=opt$header_gwas))

info_eqtl <- eval(parse(text=opt$info_eqtl))
info_gwas <- eval(parse(text=opt$info_gwas))

run_coloc(eqtl_data = opt$eqtl, gwas_data = opt$gwas, 
        return_object = FALSE, return_file = TRUE, 
        out = opt$out, 
        gwas_header = header_gwas, eqtl_header = header_eqtl, 
        p1 = opt$p1, p2 = opt$p2, p12 = opt$p12, 
        eqtl_info = info_eqtl, 
        gwas_info = info_gwas, 
        locuscompare_thresh = locuscompare_thresh
      )
