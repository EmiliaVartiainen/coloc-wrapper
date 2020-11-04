# COLOC pipeline

This pipeline facilitates easy usage of `coloc` (Giambartolomei et al. 2014, Wallace 2020) with GWAS and eQTL data. 

## Pitfalls and things to consider

1. Region of interest (only one causal variant)

2. Population sample difference between eqtl and gwas datasets. 

3. Choice of parameters: p1, p2, p12

## Usage

Running the pipeline involves two steps: 
1. Trimming data according to predefined regions
2. Running coloc.

### 1. Trimming data

Pass on a `file` (url or path), specify a `region` in tabix fashion and give a `out` filename. 

```
Rscript extdata/step1_subset_data.R	\
	--file=ftp://ftp.ebi.ac.uk/pub/databases/spot/eQTL/csv/Lepik_2017/ge/Lepik_2017_ge_blood.all.tsv.gz \
	--region="1:10565520-10965520" \
    --out=tmp.txt
```

### 2. Run coloc

- `eqtl` and `gwas` point to datasets for a specific region in which colocalization is performed. The GWAS dataset should only contain one phenotype. The eQTL dataset can contain multiple genes. Colocalization is perform for each gene. 
- `header_eqtl` and `header_eqtl` contain the column names. `varid` can be any var
- `` and ``
- `p1`, `p2` and `p12` priors that need to be specified. 
- `info_locuscompare`

```
Rscript extdata/step2_run_coloc.R	\
	--eqtl="extdata/Lepik_2017_ge_blood_chr1_ENSG00000142655_ENSG00000130940.all.tsv" \
	--gwas="extdata/I9_VARICVE_chr1.tsv.gz" \
	--out="tmp.txt" \
	--header_eqtl="c(varid = 'rsid', pvalues = 'pvalue', MAF = 'maf', gene_id = 'gene_id')" \
	--header_gwas="c(varid = 'rsids', pvalues = 'pval', MAF = 'maf')" \
	--info_gwas="list(type = 'cc', s = 11006/117692, N  = 11006 + 117692)" \
	--info_eqtl="list(type = 'quant', sdY = 1, N = 491)" \
	--info_locuscompare="list(rsid_eqtl = 'rsid', rsid_gwas = 'rsids', pval_eqtl = 'pvalue', pval_gwas = 'pval', pop = 'EUR')" \
	--p1=1e-4 \
	--p2=1e-4 \
	--p12=1e-5

Rscript extdata/step2_run_coloc.R --help

```	

## Output files

### Text file

- `gene_id`: gene identifier
- `nsnps`: number of SNPs included in colocalization
- `PP.H0.abf`: Posterior probability that neither trait has a genetic association in the region
- `PP.H1.abf`: Posterior probability that only trait 1 has a genetic association in the region
- `PP.H2.abf`: Posterior probability that only trait 2 has a genetic association in the region
- `PP.H3.abf`: Posterior probability that both traits are associated, but with different causal variants
- `PP.H4.abf`: Posterior probability that both traits are associated and share a single causal variant


For more details to output columns see [coloc-package](https://chr1swallace.github.io/coloc/articles/a03_enumeration.html#introduction).

### Locuscompare plot for each gene

Locuscompare (Liu et al. 2019).



### Sample size

Sample size GWAS: 
```
gsutil cat gs://finngen-production-library-green/R3/summary_stats/R3_pheno_n.txt | grep "I9_VARICVE"
```

Sample size eqtl, see https://www.ebi.ac.uk/eqtl/Datasets/


## Docker

```
sudo docker build -t coloc-wrapper -f docker/Dockerfile .

sudo docker run -it -v /mnt/disks/1/projects/COLOC:/COLOC -w /COLOC coloc-wrapper /bin/bash

```

## Unit tests

`Rscript -e 'testthat::test_dir("tests/testthat/")'`


## References

- **Original coloc paper**: Giambartolomei, C., Vukcevic, D., Schadt, E.E., Franke, L., Hingorani, A.D., Wallace, C., Plagnol, V., 2014. Bayesian Test for Colocalisation between Pairs of Genetic Association Studies Using Summary Statistics. PLOS Genetics 10, e1004383. https://doi.org/10.1371/journal.pgen.1004383
- **Updates on coloc**: Wallace, C., 2020. Eliciting priors and relaxing the single causal variant assumption in colocalisation analyses. PLOS Genetics 16, e1008720. https://doi.org/10.1371/journal.pgen.1008720
- **Importance of visualizing locus**: Liu, B., Gloudemans, M.J., Rao, A.S., Ingelsson, E., Montgomery, S.B., 2019. Abundant associations with gene expression complicate GWAS follow-up. Nat Genet 51, 768–769. https://doi.org/10.1038/s41588-019-0404-0 (see also [locuscomparer](https://github.com/boxiangliu/locuscomparer))



