#!/bin/bash
    set -e
    set -u
    set -o pipefail

tagseq = "/Applications/bioinformatics/tag-based_RNAseq/"

# loop through sample files
for file in *.fastq
do
    #strip .fastq and directorys tructure from each file, then
    # add suffice .fastq.trim to create output name for each file
    results_file="$(basename -s file .fastq).fastq.trim"

    # run tagseq scripts on each file
    {tagseq}tagseq_clipper.pl file | \
    fastx_clipper -a AAAAAAAA -l 20 -Q33 | \
    fastx_clipper -a AGATCGGAAG -l 20 -Q33 | \
    fastq_quality_filter -Q33 -q 20 -p 90 >\
    ../tagseq_trim/$results_file
done