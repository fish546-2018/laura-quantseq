# laura-quantseq

**Project:** _Carryover effects of parental low pH exposure in the Olympia oyster (Ostrea lurida)_  

**Data:** Differential gene expression analysis in _O. lurida_ gonad and larvae using QuantSeq. 

This repo is dedicated to processing and analyzing QuantSeq data from Olympia oyster (_Ostrea lurida_) gonad and larvae, which is part of the 2016-2018 project investigating carryover effects of adult pH exposure on reproduction and the next generation. The broader project repo can be found here: [O.lurida_Stress](https://github.com/laurahspencer/O.lurida_Stress)  

Goals for this class:  
  - Assemble a full transcriptome for Puget Sound Olympia oysters using Katherine's RNASeq data (not from my samples).    
  - Build a pipeline to take raw QuantSeq data, align with transcriptome, assess quality/check for errors, annotate, and produce a matrix for differential expression analysis. I believe the following are steps required:  
  - 1) concatenating raw sequence files according to the sampling design;   
  - 2) adaptor trimming, quality filtering and removal of PCR duplicates (?);    
  - 3) mapping against reference transcriptome;   
  - 4) deriving gene counts   

## Directory structure: 

### data: Original/raw unadulterated data files, or links to data files if >100MB  
--> _test-data:_ Practice data from Katherine for pipeline developing   
----> oly_Trinityv2.txt: raw read counts mapped to each gene in an assembled transcriptome  
----> trinity_go_annotations.txt: the Gene Ontology annotations for mapped genes in the oly_Trinityv2.txt file. 
### notebooks: RMarkdown or Jupyter notebooks of each step in processing and analysis. 
### plots: Data plots   
### references: Source code, papers, tutorials, etc  
----> DeSeq2_Oyster_Trinity-clean.ipynb: Katherine's notebook for DGE using DeSeq2 R program 
### results: processed and/or analyzed data   
### scripts: R or bash scripts   
### laura-quantseq.Rproj: RMarkdown project file where all R scripts are executed   

## Project Timeline: 
- Week 4: Hunt and gather. Read through [Misha Matz's lab resources](https://github.com/z0on/tag-based_RNAseq), plan the necessary steps I'll need to take to process QuantSeq data, identify programs/resources to accomplish each step. Identify pipeline to assemble transcriptome using just Puget Sound Oly RNASeq data.  
- Week 5: Continue steps from week 4. Use abridged RNASeq dataset to start testing assembly pipeline. Concatenate raw sequence files according to design (?).  
- Week 6: Continue testing assembly pipeline. Adapter trimming, quality filtering ... 
- Week 7: Execute transcriptome assembly?  Removal of PCR duplicates, if applicable, derive gene counts!  
- Week 8: NA   
- Week 9: Assess assembly somehow.  Re-fun all quantseq steps using my assembled transcriptome.  
- Week 10: Diff. expression analysis on gene counts using scripts from multivariate class.   


