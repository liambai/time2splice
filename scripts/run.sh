#!/bin/bash

#SBATCH -n 1
#SBATCH --mem=16G
#SBATCH -t 1:00:00

module load anaconda/2020.02
source /gpfs/runtime/opt/anaconda/2020.02/etc/profile.d/conda.sh
conda activate time2splice_env

DATADIR=$1
OUTDIR=$2

python3 ./preprocess/1_create_folder_structure.py ${OUTDIR}
./preprocess/2_run_fastQC.sh 1 ${DATADIR} ${OUTDIR}/time2splice/results/preprocess/fastqc
# ./3_run_trim_galore.sh 1 
