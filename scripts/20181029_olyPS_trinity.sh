#!/bin/bash
## Job Name
#SBATCH --job-name=20181030_olyPS_trinity
## Allocation Definition 
#SBATCH --account=srlab
#SBATCH --partition=srlab
## Resources
## Nodes
#SBATCH --nodes=1
## Walltime (days-hours:minutes:seconds format)
#SBATCH --time=120:00:00
## Memory per node
#SBATCH --mem=120G
##turn on e-mail notification
#SBATCH --mail-type=ALL
#SBATCH --mail-user=lhs3@uw.edu
## Specify the working directory for this job
#SBATCH --workdir=/gscratch/srlab/lhs3/20181030_trinity_olyPS_RNAseq

# Load Python Mox module for Python module availability

module load intel-python3_2017

# Document programs in PATH (primarily for program version ID)

date >> system_path.log
echo "" >> system_path.log
echo "System PATH for $SLURM_JOB_ID" >> system_path.log
echo "" >> system_path.log
printf "%0.s-" {1..10} >> system_path.log
echo ${PATH} | tr : \\n >> system_path.log



# Run Trinity
/gscratch/srlab/programs/Trinity-v2.8.3/Trinity \
--trimmomatic \
--seqType fq \
--max_memory 500G \
--CPU 28 \
--output /gscratch/srlab/lhs3/outputs/trinity20181029/ \
--left \
/gscratch/srlab/lhs3/inputs/CP-4Spl_S11_L004_R1_0343.fastq.gz,\
/gscratch/srlab/lhs3/inputs/CP-4Spl_S11_L004_R1_0348.fastq.gz,\
--right \
/gscratch/srlab/lhs3/inputs/CP-4Spl_S11_L004_R2_0343.fastq.gz,\
/gscratch/srlab/lhs3/inputs/CP-4Spl_S11_L004_R2_0348.fastq.gz