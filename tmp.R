
DIR <- "extdata/"
dir_gwas <- paste0(DIR, "" )
dir_eqtl <- paste0(DIR, "" )
  
eqtl <- read.table(file = dir_eqtl, header=T, as.is=T); head(eqtl) gwas <- read.table(file="[path to]/CAD_GWAS.txt", header=T, as.is=T); head(gwas)
gwas <- read.table(file = dir_gwas, header=T, as.is=T); head(eqtl) gwas <- read.table(file="[path to]/CAD_GWAS.txt", header=T, as.is=T); head(gwas)

input <- merge(eqtl, gwas, by="rs_id", all=FALSE, suffixes=c("_eqtl","gwas") head(input)
result <- coloc.abf(dataset1=list(pvalues=input$pval_nominal_gwas, type="cc", S=0.33, N=nrow(gwas)) dataset2=list(pvalues=input$pval_nominal_eqtl, type="quant", N=nrow(eqtl)), MAF=input$maf)


## locuscompare
gwas_fn="[path to]/CAD_GWAS.txt"
eqtl_fn="[path to]/Artery_Coronary_v7_eQTL_PHACTR1.txt"
marker_col="rs_id"
pval_col="pval_nominal"

Run locuscompare to visualize: locuscompare(in_fn1=gwas_fn, in_fn2=eqtl_fn, title1="GWAS", title2="eQTL", marker_col1= marker_col, pval_col1=pval_col, marker_col2=marker_col, pval_col2=pval_col))

