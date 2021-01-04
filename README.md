<img src="https://github.com/ashleymaeconard/time2splice/blob/master/img/time2splice_logo.png" width="100%">

### A method to identify temporal and sex-specific alternative splicing from multi-omics data

####  Author: Ashley Mae Conard

Motivation
==========
Alternative splicing can occur in at least 3/4th of human genes to encode two or more splice isoforms, and these isoforms occur in different proportions over time, and between sexes. Thus, we present a method to characterize these isoforms, so to better understand gene regulation happening in normal and diseased states. Time2splice identifies temporal and sex-specific alternative splicing combinding multi-omic (i.e. both expression via RNA-seq, and protein-DNA interaction via CUT&RUN and ChIP-seq) data. Analysis is done in 3 parts. 1) Temporal expression analysis, 2) Temporal protein-DNA analysis, and 3) Temporal multi-omics integration.

**NOTE: Snakemake coming soon to use time2splice efficiently**

Temporal expression analysis
==========

`1_run_salmon.sh`

Run salmon to quantify transcript expression for treatment and control samples.

e.g. `./1_run_salmon.sh /nbu/compbio/aconard/larschan_data/sexed_embryo/ /data/compbio/aconard/splicing/results/salmon_results_ncbi_trans/ /data/compbio/aconard/BDGP6/transcriptome_dir/pub/infphilo/hisat2/data/bdgp6_tran/genome.fa 3 10 1 _001.fastq.gz` 

`2_run_suppa.sh`

Run Suppa for treatment and control samples.

e.g. `./2_run_suppa.sh /data/compbio/aconard/splicing/results/salmon_results/ /data/compbio/aconard/splicing/results/suppa_results_ncbi_trans/ /data/compbio/aconard/BDGP6/transcriptome_dir/pub/infphilo/hisat2/data/bdgp6_tran/genome.fa 20`

`3_suppa_formatting.py`

Converts NM_ gene names to flybase name, then merging outputs from run_suppa (NM_ gene names by 1 TPM value column for each replicate)

4_suppa.sh

Identifies various forms of differential splicing (e.g. using PSI and DTU)

`5_calc_total_alt_splicing_controls.py`

Calculate and plot the proportions of alternative splicing (in pie chart) in control samples.

`6_calc_total_alt_differential_splicing.py`

Calculate and plot the proportions of alternative splicing (in pie chart) in treatment samples.

`7_get_bias_genes.py`

Retrieve male and female biased genes and create bed files for average profile plotting.

`8_plots_splicing.ipynb`

Plotting transcript expression using PSI and DTU measures.

`8_alt_plots_splicing.ipynb`

Alternative code base to plot transcript expression using PSI and DTU measures.

`9_plots_splicing_time.ipynb`

Plot alternative splicing genes within categories (all females, all males, females sex specific, male sex specific, female all rest, male all rest, female non-sex specific, male non-sex specific, female new sex specific, male new sex specific) over time.

Temporal protein-DNA analysis
==========


Temporal multi-omics integration
==========
