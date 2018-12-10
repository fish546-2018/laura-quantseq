# laura-quantseq

## _Carryover effects of parental low pH exposure in the Olympia oyster (Ostrea lurida)_  

Using QuantSeq data I hope to answer these questions: 
  - Does low pH exposure affect gene expression in _O. lurida_ gonad?  
  - Does parental low pH exposure affect gene expression in larvae?  

This repo is dedicated to processing and analyzing QuantSeq data from Olympia oyster (_Ostrea lurida_) gonad and larvae, which is part of the 2016-2018 project investigating carryover effects of adult pH exposure on reproduction and the next generation. The broader project repo can be found here: [O.lurida_Stress](https://github.com/laurahspencer/O.lurida_Stress)  

### What I did 

This is what I did with QuantSeq data and separate RNAseq data to answer the above questions:  
- Assembled gonad transcriptome specific to Puget Sound Olympia oyster populations for QuantSeq reference:    
  - Used RNASeq data sequenced by Katherine Sillliman from a pooled library of gonad tissue taken my project's oysters post ocean acidification exposure (Fidalgo Bay and Oyster Bay populations). Assembly was performed using Trinity.  
  - Annotated transcriptome using blast and the Uniprot database.  
  - Collapsed transcriptome to remove isoforms.  
- Generated counts from QuantSeq data:  
  - Assess quality of QuantSeq data using FastQC <-- I haven't actually done this yet!  
  - Trimmed adaptors, quality filtered and removed PCR duplicates (using [these instructions, tagSeq_processing_README.txt](https://raw.githubusercontent.com/z0on/tag-based_RNAseq/master/tagSeq_processing_README.txt) . 
  - Use Kallisto and the denovo transcriptome to generate pseudo-counts.  
  - Use Bowtie to align QuantSeq data to transcriptome. Have yet to use this alignment data.  
- With pseudocounts from Kallisto, assessed for differential expression by pH/parental pH using DESeq and PCA.   

### Visualizations

PCA biplots of gonad and larva counts, and scatter plots showing differentially expressed genes. 
[images here]() 
  
### Next Steps 

This is what I still need to do, probably(?):  
  - Generate feature tracks for my denovo-assembled transcriptome?   
  - Return to Bowtie-aligned quantseq data to generate more accurate counts ... how to do this?  
  - Trouble shoot perl 1-liner to finish the TagSeq processing pipeline, see if my PCA/DESeq results change!  
  
## Directory structure: 

### data 
Raw and processed data files, or links to data files if >100MB   
  - **quantseq_key.csv**: Important metadata - sequence file name and corresponding sample number, treatment, etc.  
  - **quantseq-sample-origin.md**: Information on the samples sent to Katherine 
  - **illumina-raw/**: QuantSeq raw data files. Note, most are larger than 100MB, but can be downloaded from owl: [wetgenes/20181109_QS_Laura](http://owl.fish.washington.edu/wetgenes/20181109_QS_Laura/)  

### notebooks  
RMarkdown or Jupyter notebooks of each step in processing and analysis. 
  - **Inspecting fastq files.ipynp**: 
  - **QuantSeq-DeSeq.Rmd**: Using DeSeq on my quantseq count data . 
  - **QuantSeq-Diff-PCA.Rmd**: PCA analysis and biplot visualization - note this uses transformed data created by the DeSeq notebook.  
  - **QuantSeq-multivariate-analysis.Rmd**: Random data processing using the count matrix from Kallisto, probably not going to retain this notebook.  
  - **Quantseq-processing-using-genome.ipynb**: Trying to generate QuantSeq read counts using the Oly genome, since it comes with great feature tracks. Abandoned. 
  - **Quantseq-processsing**: All QuantSeq processing steps up to Kallisto, including generating a collapsed transcriptome (I should move this to a different notebook). Also contains Bowtie2 alignment which was not succesfful. Needs cleaning.  
  - **RNASeq-screening** (.md, .Rmd, and \_files): Assessing quality of RNASeq data used for transcriptome, using R program following the Bioinf. textbook instructions.  
  - **transcriptome-assess-annotate.ipynb**: Generating statistics on Trinity-assembled transcriptome, and annotating using Blast.  
  - **Trinity for Kallisto QuantSeq Counts.ipynb**:  Generating pseudocounts using Kallisto, which is incorporated into the Trinity package.  
  - **trinity-setu-on-mox.md**: Commands/steps needed to run Trinity on mox (Jupyter Notebok on Mox is complicated, so I just copied from the terminal).  
  
### plots  
Data plots   
TBD 

### references  
Source code, papers, tutorials, etc  
  - **DeSeq2_Oyster_Trinity-clean.ipynb**: Katherine's notebook for DGE using DeSeq2 R program 
  - **Olurida_v081.fa**: Most recent Oly genome (>100MB, so not on GitHub). 
  - **Olurida_v081.fa.fai**: Indexed Oly genome for IGV.  
  - **tagSeq_processing.txt**: Pipeline used as reference for processing tagseq data, recommended to me by Katherine. The original is located [here](https://github.com/z0on/tag-based_RNAseq/blob/master/tagSeq_processing_README.txt). 

### results
Analyzed data, etc. 
  - **20181029-olurida-gonad-assembly_seq2iso.tab**: Attempted results of the perl script to assign isogroups. Failed.   
  - **blast/**: Blast results, transcriptome against Uniprot database; ps-oly-gonad-unitprot_blastx.tab.  
  - **bowtie**: results of Bowtie - Need to move my files from the data/tag-seq/ directory here.  
  - **DESeq**: Important! Transformed gene counts, diff. expressed genes.  
  - **fastqc/**: FastQC results of untrimmed/ and trimmed/ RNASeq data 
  - **kallisto**: Results froj Kallisto for gene pseudo-counts. Most important files: 
    - 1129matrix-trans_counts.isoform.counts.matrix: The 'counts.matrix' file is used for downstream analyses of differential expression.  
    - 1129matrix-trans_counts.isoform.TMM.EXPR.matrix: The TMM.EXPR.matrix file is used as the gene expression matrix in most other analyses; counts are cross-sample normalized. <--- need to figure out exactly how!  
  - **tagseq_trim/**: A bunch of versions of my tagseq data: trimmed fastq (.trim), SAM files (.sam), sorted BAM files (.bam), and BAM index files (.bai).
  - **test-data/**: Practice data from Katherine for pipeline developing   
    - oly_Trinityv2.txt: raw read counts mapped to each gene in an assembled transcriptome
    - trinity_go_annotations.txt: the Gene Ontology annotations for mapped genes in the oly_Trinityv2.txt file.   
  - **trimgalore/**: RNASeq data that has veen trimmed using `trimgalore!`. This was not actually used for transcriptome assembly, since I used Trimmomatic built into the Trinity program.  

### scripts 
R or bash scripts   
  - **20181029_olyPS_trinity.sh**: SLURM used to execute Trinity transcriptome assembly on Mox.    
  - **download-quantseq.sh**: Script used to download QuantSeq files from Owl.  
  - **scripting-quiz.sh**: 

### In this parent directory  
README.md  
  - **laura-quantseq.Rproj**: RMarkdown project file where all R scripts are executed   
  - **Process-presentation.pptx & .pdf**:  presentation file with bioinformatics and data analysis workflow   


## Project Timeline: 
- Week 4: Hunt and gather. Read through [Misha Matz's lab resources](https://github.com/z0on/tag-based_RNAseq), plan the necessary steps I'll need to take to process QuantSeq data, identify programs/resources to accomplish each step. Identify pipeline to assemble transcriptome using just Puget Sound Oly RNASeq data.  
- Week 5: Continue steps from week 4. Use abridged RNASeq dataset to start testing assembly pipeline. Concatenate raw sequence files according to design (?).  
- Week 6: Continue testing assembly pipeline. Adapter trimming, quality filtering ... 
- Week 7: Execute transcriptome assembly?  Removal of PCR duplicates, if applicable, derive gene counts!  
- Week 8: NA   
- Week 9: Assess assembly somehow.  Re-fun all quantseq steps using my assembled transcriptome.  
- Week 10: Diff. expression analysis on gene counts using scripts from multivariate class.   

