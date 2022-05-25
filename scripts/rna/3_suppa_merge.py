import pandas as pd
import argparse
import glob

import os

from functools import reduce

parser = argparse.ArgumentParser()

parser.add_argument("inputdir")
parser.add_argument("suppadir")
args = parser.parse_args()

files = [file for file in glob.glob(args.inputdir+"/*/iso_tmp.txt")]
files_str = " ".join(files)
# print(f"python3 {args.suppadir}/suppa.py joinFiles -f tpm -i {files_str}")
os.system(f"python3 {args.suppadir}/suppa.py joinFiles -f tpm -i {files_str} -o {args.inputdir}/merged")

    # df = pd.read_csv(file, sep="\t", index_col=0)
    # df.index.names=['gene_id']

    # dfs.append(df)

# df_merged = reduce(lambda left, right: pd.merge(left, right, on=['gene_id']), dfs)
# df_merged.to_csv(args.inputdir+"/iso_tpm_merged.txt", sep="\t")