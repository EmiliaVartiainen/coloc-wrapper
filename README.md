# COLOC pipeline

## Usage
```
Rscript run_coloc.R	\
	--gwasSumstats=finngen_R5_I9_VARICVE.gz \
	--gwasSumstatsTop=finngen_R5_I9_VARICVE_top_loci.tsv \
	--eqtlSumstats=eqtl_catalog_Lepik_2017.txt.gz \
    --outDir=pathtooutputdirectory
```	

tabix_paths = read.delim("https://raw.githubusercontent.com/eQTL-Catalogue/eQTL-Catalogue-resources/master/tabix/tabix_ftp_paths.tsv", 

/Users/eahvarti/Documents/coloc_analysis/Data/finngen_R5_I9_VARICVE_top_loci.tsv", sep = "\t", header = TRUE, nrows = 1))
