# COLOC pipeline

## Usage
```
Rscript extdata/step1_subset_data.R	\
	--eqtl="ftp://ftp.ebi.ac.uk/pub/databases/spot/eQTL/csv/Lepik_2017/ge/Lepik_2017_ge_blood.all.tsv.gz" \
	--gwas=I9_VARICVE.gz \
	--region="1:10565520-10965520" \
    --out=/outdir/

Rscript extdata/step2_run_coloc.R	\
	--eqtl=/COLOC/extdata/Lepik_2017_ge_blood_chr1_ENSG00000130940.all.tsv \
	--gwas=/COLOC/extdata/I9_VARICVE_chr1.tsv \
    --out=/outdir/
```	

### Sample size

Sample size GWAS: 
```
gsutil cat gs://finngen-production-library-green/R3/summary_stats/R3_pheno_n.txt | grep "I9_VARICVE"
```

Sample size eqtl, see https://www.ebi.ac.uk/eqtl/Datasets/

## Unit tests

`testthat::test_dir("tests/")`

## Docker

```
sudo docker build -t coloc-wrapper -f docker/Dockerfile .

sudo docker run -it \
-v /mnt/disks/1/projects/COLOC:/COLOC \
-v /mnt/disks/1/data:/data \
coloc-wrapper /bin/bash

```

## References

- **Original coloc paper**: Giambartolomei, C., Vukcevic, D., Schadt, E.E., Franke, L., Hingorani, A.D., Wallace, C., Plagnol, V., 2014. Bayesian Test for Colocalisation between Pairs of Genetic Association Studies Using Summary Statistics. PLOS Genetics 10, e1004383. https://doi.org/10.1371/journal.pgen.1004383
- **Updates on coloc**: Wallace, C., 2020. Eliciting priors and relaxing the single causal variant assumption in colocalisation analyses. PLOS Genetics 16, e1008720. https://doi.org/10.1371/journal.pgen.1008720
- **Importance of visualizing locus**: Liu, B., Gloudemans, M.J., Rao, A.S., Ingelsson, E., Montgomery, S.B., 2019. Abundant associations with gene expression complicate GWAS follow-up. Nat Genet 51, 768–769. https://doi.org/10.1038/s41588-019-0404-0 (see also [locuscomparer](https://github.com/boxiangliu/locuscomparer))



