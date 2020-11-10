# COLOC wrapper

This pipeline facilitates easy usage of `coloc` (Giambartolomei et al. 2014, Wallace 2020) with GWAS and eQTL data. 

Colocalization analysis is used to detect genetic causality between two different GWAS traits. Coloc-wrapper performs genetic colocalization analysis for GWAS and eQTL datasets in a given region using `coloc.abf()` function from Coloc R-package. It calculates posterior probabilities for the following five hypothesis for each gene in the region under the assumption of a single causal variant for each trait:

<img src="https://render.githubusercontent.com/render/math?math=H_{0}">: no association <br />
<img src="https://render.githubusercontent.com/render/math?math=H_{1}">: association to trait 1 only <br />
<img src="https://render.githubusercontent.com/render/math?math=H_{2}">: association to trait 2 only <br />
<img src="https://render.githubusercontent.com/render/math?math=H_{3}">: association to both traits, distinct causal variants <br />
<img src="https://render.githubusercontent.com/render/math?math=H_{4}">: association to both traits, shared causal variant <br />

The posterior probability of hypothesis 4, PP4, determines the possible colocalization. A common threshold for it is PP4 > 0.8.


## Getting started
### I on local machine
- R version >3.6.2
- R-packages: "coloc", "data.table", "ggplot2", "optparse", "R.utils"
- tabix

### II using docker

```
sudo docker build -t coloc-wrapper -f docker/Dockerfile .

sudo docker run -it -v /mnt/disks/1/projects/COLOC:/COLOC -w /COLOC coloc-wrapper /bin/bash

```

## Data 
The input files are the following:

### 1. GWAS summary statistics


### 2. eQTL summary statistics
- eQTL data can be found here: https://www.ebi.ac.uk/eqtl/ 

### 3. Region 

## Usage
Running coloc-wrapper involves two steps: <br />
1. Trimming data, both GWAS and eQTL, according to a predefined region <br />
2. Running coloc <br />

### 1. Trimming data
- `file`: GWAS or eQTL file path or url
- `region`: genomic region of interest, format `chr:start-end`
- `out`: output file 

```
Rscript extdata/step1_subset_data.R	\
	--file=ftp://ftp.ebi.ac.uk/pub/databases/spot/eQTL/csv/Lepik_2017/ge/Lepik_2017_ge_blood.all.tsv.gz \
	--region="1:10565520-10965520" \
  --out=tmp.txt
```

### 2. Run coloc 
- `gwas`: GWAS summary statistics file for one region
- `eqtl`: eQTL summary statistics file for one region
- `header_gwas`: header of GWAS file, named vector in quotes
- `header_eqtl`: header of eQTL file, named vector in quotes
- `info_gwas`: options for GWAS dataset, more info [here](https://www.rdocumentation.org/packages/coloc/versions/3.2-1/topics/coloc.abf)
    - `type`: the type of data in dataset - either "quant" or "cc" to denote quantitative or case-control
    - `s`: for a case control dataset, the proportion of samples in dataset that are cases
    - `N`: number of samples in the dataset
- `info_eqtl`: options for eQTL dataset, more info [here](https://www.rdocumentation.org/packages/coloc/versions/3.2-1/topics/coloc.abf)
    - `type`: the type of data in dataset - either "quant" or "cc" to denote quantitative or case-control
    - `sdY`: for a quantitative trait, the population standard deviation of the trait. if not given, it can be estimated from the vectors of varbeta and MAF
    - `N`: number of samples in the dataset
- `p1`: the prior probability that any random SNP in the region is associated with exactly trait 1
- `p2`: the prior probability that any random SNP in the region is associated with exactly trait 2
- `p3`: the prior probability that any random SNP in the region is associated with both traits
- `locuscompare_thresh`: PP4 threshold that plots the locuscompare plots
- `out`: output file

```
Rscript extdata/step2_run_coloc.R	\
	--eqtl="extdata/Lepik_2017_ge_blood_chr1_ENSG00000142655_ENSG00000130940.all.tsv" \
	--gwas="extdata/I9_VARICVE_chr1.tsv.gz" \
	--header_eqtl="c(varid = 'rsid', pvalues = 'pvalue', MAF = 'maf', gene_id = 'gene_id')" \
	--header_gwas="c(varid = 'rsids', pvalues = 'pval', MAF = 'maf')" \
	--info_gwas="list(type = 'cc', s = 11006/117692, N  = 11006 + 117692)" \
	--info_eqtl="list(type = 'quant', sdY = 1, N = 491)" \
	--p1=1e-4 \
	--p2=1e-4 \
	--p12=1e-5 \
	--locuscompare_thresh=0.8 \
	--out="Coloc_example.txt" \
```
## Output 


### Text file

- `gene_id`: gene identifier
- `nsnps`: number of SNPs included in colocalization
- `PP.H0.abf`: Posterior probability that neither trait has a genetic association in the region
- `PP.H1.abf`: Posterior probability that only trait 1 has a genetic association in the region
- `PP.H2.abf`: Posterior probability that only trait 2 has a genetic association in the region
- `PP.H3.abf`: Posterior probability that both traits are associated, but with different causal variants
- `PP.H4.abf`: Posterior probability that both traits are associated and share a single causal variant


For more details to output columns see [coloc-package](https://chr1swallace.github.io/coloc/articles/a03_enumeration.html#introduction).

### Locuscompare

## Alternative coloc-wrapper

An alternative coloc-wrapper: https://github.com/eQTL-Catalogue/colocalisation


## Pitfalls and things to consider

1. Locuscompare population. 
Default set to EUR

For more options see https://github.com/boxiangliu/locuscomparer. 

2. Population sample difference between eqtl and gwas datasets. 

See Wallace 2020. 

3. Choice of parameters

p1, p2, p12

See Wallace 2020. 


## Unit tests

`Rscript -e 'testthat::test_dir("tests/testthat/")'`


## References

- **Original coloc paper**: Giambartolomei, C., Vukcevic, D., Schadt, E.E., Franke, L., Hingorani, A.D., Wallace, C., Plagnol, V., 2014. Bayesian Test for Colocalisation between Pairs of Genetic Association Studies Using Summary Statistics. PLOS Genetics 10, e1004383. https://doi.org/10.1371/journal.pgen.1004383
- **Updates on coloc**: Wallace, C., 2020. Eliciting priors and relaxing the single causal variant assumption in colocalisation analyses. PLOS Genetics 16, e1008720. https://doi.org/10.1371/journal.pgen.1008720
- **Importance of visualizing locus**: Liu, B., Gloudemans, M.J., Rao, A.S., Ingelsson, E., Montgomery, S.B., 2019. Abundant associations with gene expression complicate GWAS follow-up. Nat Genet 51, 768–769. https://doi.org/10.1038/s41588-019-0404-0 (see also [locuscomparer](https://github.com/boxiangliu/locuscomparer))



