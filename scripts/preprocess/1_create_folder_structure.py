import os, sys

DIR = sys.argv[1]

if not os.path.exists(DIR):
    os.makedirs(DIR)

def create_folder(FULL_DIR, TO_ADD):
    if not os.path.exists(FULL_DIR+TO_ADD):
        os.makedirs(FULL_DIR+TO_ADD)

def create_file_structure():
    # Creating output directory trees as needed
    # Creating data stage
    create_folder(DIR,"/time2splice/")
    create_folder(DIR,"/time2splice/data/")
    create_folder(DIR,"/time2splice/data/fastq/")
    create_folder(DIR,"/time2splice/data/counts/")

    # Creating results stage
    create_folder(DIR,"/time2splice/results/")
        
    # Creating results preprocess stage
    create_folder(DIR,"/time2splice/results/preprocess/")
    create_folder(DIR,"/time2splice/results/preprocess/fastqc/")
    create_folder(DIR,"/time2splice/results/preprocess/alignment/")
    create_folder(DIR,"/time2splice/results/preprocess/count_matrix/")
    create_folder(DIR, "/time2splice/results/preprocess/count_matrix/htseq/")
    
    # Creating results primary and secondary stage analyses    
    create_folder(DIR,"/time2splice/results/analysis/")

if __name__ == "__main__":
    create_file_structure()