#!/bin/bash
    set -e
    set -u
    set -o pipefail

# Download only files from BC with sample numbers in the 40's, 50's or 60's 

wget --accept "CP-KS-Lib3-BC-[4-6][0-9]C_*.fastq.gz" \
--no-directories --recursive --no-parent \
http://owl.fish.washington.edu/wetgenes/201803_QuantSeq_Raw/ \
-P data/test-data

# create a .txt file for downloaded quantseq file names 
touch data/test-data/quatseq-files.txt 

# print the file names to a text file 
ls data/test-data/*.fastq.gz >> data/test-data/quatseq-files.txt 

# return list of files downloaded 
echo "downloaded files:"
cat data/test-data/quatseq-files.txt

