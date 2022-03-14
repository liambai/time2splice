#!/bin/bash

#SBATCH -n 4
#SBATCH --mem=16G
#SBATCH -t 12:00:00

module load anaconda/2020.02
source /gpfs/runtime/opt/anaconda/2020.02/etc/profile.d/conda.sh
conda activate time2splice_env

DATADIR=$1
OUTDIR=$2

# rm -r ${OUTDIR}

PREPROCESS_RES_DIR=${OUTDIR}/time2splice/results/preprocess

python3 ./preprocess/1_create_folder_structure.py ${OUTDIR}
# ./preprocess/2_run_fastQC.sh 4 ${DATADIR}/fastq ${PREPROCESS_RES_DIR}/fastqc
# ./preprocess/3_run_trim_galore.sh 4 ${DATADIR}/fastq ${PREPROCESS_RES_DIR}/trim_galore_fastqc 30
./preprocess/4_run_Bowtie2.sh ${DATADIR}/fastq ${PREPROCESS_RES_DIR}/alignment 1 ${DATADIR}/reference/index/dmel_all_chromosome