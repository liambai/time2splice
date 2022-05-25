import pandas as pd
import argparse
import glob

from functools import reduce

parser = argparse.ArgumentParser()

parser.add_argument("inputdir")
args = parser.parse_args()

dfs = []

for file in glob.glob(args.inputdir+"/*/iso_tmp.txt"):
    df = pd.read_csv(file, sep="\t", index_col=0)
    df.index.names=['gene_id']

    dfs.append(df)

df_merged = reduce(lambda left, right: pd.merge(left, right, on=['gene_id']), dfs)
df_merged.to_csv(args.inputdir+"/iso_tpm_merged.txt", sep="\t")