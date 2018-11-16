#!/bin/bash
    set -e
    set -u
    set -o pipefail

# create directory to house sequence files  
mkdir ../data/illumina-raw/

# Download raw quantseq data files (already demultiplexed) 

wget --accept "*.fastq.gz" \
--no-directories --recursive --no-parent \
http://owl.fish.washington.edu/wetgenes/20181109_QS_Laura/ \
-P ../data/illumina-raw/

# unzip 
gunzip -k ../data/illumina-raw/*.fastq.gz

# remove zipped files 
rm ../data/illumina-raw/*.gz

# create a .txt file for downloaded quantseq file names 
touch ../data/illumina-raw/quatseq-files.txt 

# print the file names to a text file 
ls ../data/illumina-raw/*.fastq >> ../data/illumina-raw/quatseq-files.txt 

# return list of files downloaded 
echo "downloaded the following files:"
cat ../data/illumina-raw/quatseq-files.txt
