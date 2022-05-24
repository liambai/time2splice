#!/bin/bash

#SBATCH -n 4
#SBATCH --mem=16G
#SBATCH -t 12:00:00

module load anaconda/2020.02
source /gpfs/runtime/opt/anaconda/2020.02/etc/profile.d/conda.sh
conda activate time2splice_env

DATADIR=$1
OUTDIR=$2
PATH_TO_SUPPA=$3

# rm -r ${OUTDIR}

RES_DIR=${OUTDIR}/time2splice/results

# python3 ./preprocess/1_create_folder_structure.py ${OUTDIR}
# ./preprocess/2_run_fastQC.sh 4 ${DATADIR}/fastq ${RES_DIR}/preprocess/fastqc
# ./preprocess/3_run_trim_galore.sh 4 ${DATADIR}/fastq ${RES_DIR}/preprocess/trim_galore_fastqc 30
# ./preprocess/4_run_Bowtie2.sh ${RES_DIR}/preprocess/trim_galore_fastqc ${RES_DIR}/preprocess/alignment 1 ${DATADIR}/reference/bowtie2_index/dmel_all_chromosome

# ./rna/1_run_salmon.sh ${RES_DIR}/preprocess/trim_galore_fastqc ${RES_DIR}/analysis/salmon ${DATADIR}/reference ${DATADIR}/reference/dmel-all-chromosome-r6.44.fasta 4 1 1
# /rna/2_run_suppa.sh ${RES_DIR}/analysis/salmon ${RES_DIR}/analysis/suppa ${PATH_TO_SUPPA} 1
python3 ./rna/3_suppa_merge.py ${RES_DIR}/analysis/suppa