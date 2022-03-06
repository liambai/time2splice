#!/bin/bash

#SBATCH -n 1
#SBATCH --mem=16G
#SBATCH -t 1:00:00

module load anaconda/2020.02
source /gpfs/runtime/opt/anaconda/2020.02/etc/profile.d/conda.sh
conda activate time2splice_env

FASTA=$1

bowtie2-build ${FASTA} dmel_all_chromosome