#!/bin/bash
# run_Bowtie2.sh
# Ashley Mae Conard
# Last Mod: July 11, 2019
# Runs Bowtie2 in for all .fq.gz files in a given directory

# Checking to make sure input is correct
if [ $# -ne 4 ]; then
	echo $0: "Usage: ./run_Bowtie2.sh 
            1) /PATH/TO/NAMED_FASTQ_DIR/ (NAMED folders containing replicate fastq.gz files) 
            2) /PATH/TO/RESULTS_DIR/ (desired location to add or create results directory) 
            3) PAIRED_OR_NOT (YES is 1, NO is 0) 
            4) INDEX"
	exit 1
fi

# Assigning input parameters to variable names
INPUT_DIR=$1
RESULTS_DIR=$2
PAIRED_OR_NOT=$3
INDEX=$4
ORGANISM=$5

# Checking to see if results directory exists
if [ -d "$RESULTS_DIR" ]; then
	echo "${RESULTS_DIR} already exists."
else
    mkdir $RESULTS_DIR
fi

# # Getting number of fastq files
# num_files=$(echo `ls -1q ${INPUT_DIR}/*/*/*.fastq* | wc -l`)
# echo "Number of input files: " $num_files

# Determining how many processors and commands to run in one batch
#if [ $((num_files%2)) -eq 0 ]; then # number is even
#    if [[ $num_files -gt  10 ]]; then
#        NUM_PROCESSORS=2
#        NUM_COMMANDS=5
#    else
#        NUM_PROCESSORS=$(echo $((num_files/2)))
#        NUM_COMMANDS=$(echo $((num_files - NUM_PROCESSORS)))
#    fi
#else # number is odd
#    num_filesPlus=$((num_files+1))
#	if [[ $num_files -gt  10 ]]; then
#        NUM_PROCESSORS=2
#        NUM_COMMANDS=5
#    else
#        NUM_PROCESSORS=$(echo `$((num_filesPlus / 2))`)
#        NUM_COMMANDS=$(echo `$((num_filesPlus - NUM_PROCESSORS))`)
#    fi
#fi

NUM_PROCESSORS=1
NUM_COMMANDS=1

# Checking to see if results/bowtie2/ directory exists
#if [ -d "$RESULTS_DIR/bowtie2/" ]; then
#	echo "${RESULTS_DIR}/bowtie2/ already exists."
#    OUTPUT_DIR=${RESULTS_DIR}"/bowtie2/"
#else
#    OUTPUT_DIR=${RESULTS_DIR}"/bowtie2/"
#    mkdir $OUTPUT_DIR
#fi

# Creating command script for Bowtie2
COMMAND_SCRIPT=${RESULTS_DIR}"/run_Bowtie2.txt" 

# Removing command script if already made
if [ -f ${COMMAND_SCRIPT} ]; then
	echo -e "REPLACING ${COMMAND_SCRIPT}\n"
	rm -rf ${COMMAND_SCRIPT}
fi

START=0
i=$START

echo "Processing .fq files with Bowtie2 on $NUM_PROCESSORS processors."
# Adding commands to a script.txt file
for dir in $INPUT_DIR
    do
    
    # Iterating through input directory
    if [ -d ${dir} ] ; then
        
        # Checking if RNA-seq data is paired or not
        # SINGLE END READS
        if [ "$PAIRED_OR_NOT" -ne "1" ]; then
           echo "Initiating single-end RNA-seq data processing.";
           for fastq in ${dir}/*
               do
                   echo "Getting unpaired .fq for $fastq"
                   ((i = i + 1))

                    # # If number of processors reached, add wait to form a batch that will finish, and then process the next batch
                    # if (( ${i}%${num_files}==0 )); then # had been NUM_COMMANDS
                    #     echo "wait" >> $COMMAND_SCRIPT
                    # fi 
                    fileName=$(echo `basename $fastq`) # get filename from .fq.gz
                    replicateFolder=$(echo `basename $(dirname $fastq)`)
                    sampleFolder=$(echo `basename $(dirname $(dirname $fastq))`)
                    
                    # Creating folder for all Bowtie2 outputs per file by removing R1 and R2 (e.g. MTb8-8)
                    folderName=${RESULTS_DIR}/${sampleFolder}/${replicateFolder}
                    
                    # Outputting directory for Bowtie2/sample_name
                    mkdir -p ${folderName}
                    
                    # Writing Bowtie2 command to a file, followed by .bam creation and sorting
                    echo "Adding ${fileName} to run_Bowtie2.txt script"
                    echo " "                    
                    echo "bowtie2 -p ${NUM_PROCESSORS} -x ${INDEX} -U $fastq --un-gz $folderName/out_un.sam.gz --al-gz $folderName/out_al.sam.gz --met-file $folderName/out_met-file.tsv -S $folderName/out.sam 2> $folderName/summaryfile.txt; samtools view -bS $folderName/out.sam > $folderName/out.bam; rm -rf $folderName/out.sam; samtools sort $folderName/out.bam -o $folderName/out.sorted.bam; rm -rf $folderName/out.bam" >> $COMMAND_SCRIPT  

                    echo "Outputting results to $folderName"
           done
        
        # PAIRED END READS
        else
            echo "Initiating paired-end RNA-seq data processing.";
            # Iterating through only the R1 replicates
            for R1 in ${dir}/*/*_R1_*_val_*.fq*
                do
                    echo "Getting paired .fq for $R1"
                    # Iterating through each R1 to determine when to add 'wait' to script
                    ((i = i + 1))

                    # # if number of processors reached, add wait to form a batch that will finish, and then process the next batch
                    # if (( ${i}%${num_files}==0 )); then # had been NUM_COMMANDS
                    #     echo "wait" >> $COMMAND_SCRIPT
                    # fi 

                    # Generating the Bowtie2 command for the next R1 and R2
                    fileName=$(echo `basename $R1`) # get filename from .fq.gz
                    fileParent=$(echo `basename $(dirname $R1)`)

                    # Creating folder for all Bowtie2 outputs per file by removing R1 and R2 (e.g. MTb8-8)
                    fName=$(echo ${fileName%"_val_*"}) 
                    folderName=${RESULTS_DIR}"/"${fName}

                    # Getting 2nd read pair
                    R2=${R1//"_R1_"/"_R2_"}
                    R2=${R2//"_val_1"/"_val_2"}

                    # Outputting directory for Bowtie2/sample_name
                    mkdir -p ${folderName}

                    # Writing Bowtie2 command to a file, followed by .bam creation and sorting
                    echo "Adding ${fileName} to run_Bowtie2.txt script"
                    echo " "
                    echo "bowtie2 -p ${NUM_PROCESSORS} -x ${INDEX} -1 $R1 -2 $R2 --un-conc-gz $folderName/out_unconc.sam.gz --al-conc-gz $folderName/out_al-conc.sam.gz --met-file $folderName/out_met-file.tsv -S $folderName/out.sam 2> $folderName/summaryfile.txt; samtools view -bS $folderName/out.sam > $folderName/out.bam; rm -rf $folderName/out.sam; samtools sort $folderName/out.bam -o $folderName/out.sorted.bam; rm -rf $folderName/out.bam" >> $COMMAND_SCRIPT  
            done
       fi
    fi
done
echo "wait" >> $COMMAND_SCRIPT

echo "running command script"
bash $COMMAND_SCRIPT
echo "done"