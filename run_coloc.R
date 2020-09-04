## todo
## - with varids, instead of rsids

suppressMessages(library(optparse))
suppressMessages(library(data.table))
suppressMessages(library(locuscomparer))
suppressMessages(library(coloc))

option_list <- list(
    optparse::make_option(c("--eqtl"), type="character", default= "/COLOC/extdata/Lepik_2017_ge_blood_chr1_ENSG00000130940.all.tsv",help="eQTL summary stats for one region"),
    optparse::make_option(c("--gwas"), type="character", default="/COLOC/extdata/I9_VARICVE_chr1.tsv", help = "GWAS summary stats for 1 region") ,
    optparse::make_option(c("--out"), type="character", default="/COLOC/out.txt", help = "outputfile") 
)

header_gwas <- c("varid" = "rsids", "pval" = "pval", "maf" = "maf")
header_eqtl <- c("varid" = "rsid", "pval" = "pvalue", "maf" = "maf")


opt <- optparse::parse_args(optparse::OptionParser(option_list=option_list))

print(opt)

## outname -------------------
bits <- sapply(c(opt$gwas, opt$eqtl), function(x) unlist(strsplit(basename(x), "\\."))[1])
outname <- paste0(opt$out, paste(bits, collapse = "-"))

## read data -----------------

df_eqtl <- data.table::fread(file = opt$eqtl, select = unname(header_eqtl))
names(df_eqtl) <- names(header_eqtl)
df_gwas <- data.table::fread(file = opt$gwas, select= unname(header_gwas))
names(df_gwas) <- names(header_gwas)

print(dim(df_gwas))
print(dim(df_eqtl))
print(head(outname))


