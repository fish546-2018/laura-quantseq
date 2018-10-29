### Logged ont Mox and created directories in my username 
`ssh lhs3@mox.hyak.uw.edu` 

Entered  password and authenticated using Duo 

	[lhs3@mox2 ~]$ pwd
	/usr/lusers/lhs3

Navigated to gscratch directory, where I will download my large fastq files, created a directory for myself and for my large files: 

	cd /gscratch/srlab/ 
	mkdir lhs3/
	cd lhs3/
	mkdir inputs/
	mkdir outputs/
	cd inputs/

### Getting files to Mox 

fastq files are located on Owl. 

Owl IP: 128.95.149.83
http://owl.fish.washington.edu/nightingales/O_lurida/CP-4Spl_S11_L004_R1_0343.fastq.gz
http://owl.fish.washington.edu/nightingales/O_lurida/CP-4Spl_S11_L004_R1_0348.fastq.gz
http://owl.fish.washington.edu/nightingales/O_lurida/CP-4Spl_S11_L004_R2_0343.fastq.gz
http://owl.fish.washington.edu/nightingales/O_lurida/CP-4Spl_S11_L004_R2_0348.fastq.gz

Things I tried to do to download files to mox 

	[lhs3@mox2 inputs]$ rsync —archive —progress —verbose lhs3@128.95.149.83:/nightingales/O_lurida/CP-4Spl_S11_L004_R1_0343.fastq.gz /gscratch/srlab/lhs3/inputs/

	Unexpected remote arg: lhs3@128.95.149.83:/nightingales/O_lurida/CP-4Spl_S11_L004_R1_0343.fastq.gz
	rsync error: syntax or usage error (code 1) at main.c(1214) [sender=3.0.9]

	[lhs3@mox2 inputs]$ rsync —archive —progress —verbose http://owl.fish.washington.edu/nightingales/O_lurida/CP-4Spl*.fastq.gz /gscratch/srlab/lhs3/inputs/
	Unexpected remote arg: http://owl.fish.washington.edu/nightingales/O_lurida/CP-4Spl*.fastq.gz
	rsync error: syntax or usage error (code 1) at main.c(1214) [sender=3.0.9]

None of the above worked, so I used curl, which I used on my local machine previously  

### This is what I actually did 

	[lhs3@mox2 inputs]$ curl -O -O -O -O \
	> http://owl.fish.washington.edu/nightingales/O_lurida/CP-4Spl_S11_L004_R1_0343.fastq.gz \
	>     http://owl.fish.washington.edu/nightingales/O_lurida/CP-4Spl_S11_L004_R1_0348.fastq.gz \
	>         http://owl.fish.washington.edu/nightingales/O_lurida/CP-4Spl_S11_L004_R2_0343.fastq.gz \
	>             http://owl.fish.washington.edu/nightingales/O_lurida/CP-4Spl_S11_L004_R2_0348.fastq.gz
	  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
	                                 Dload  Upload   Total   Spent    Left  Speed
	100 1672M  100 1672M    0     0  47.0M      0  0:00:35  0:00:35 --:--:-- 58.4M
	100 1859M  100 1859M    0     0  50.8M      0  0:00:36  0:00:36 --:--:-- 66.1M
	100 1821M  100 1821M    0     0  56.4M      0  0:00:32  0:00:32 --:--:-- 45.3M
	100 1970M  100 1970M    0     0  53.7M      0  0:00:36  0:00:36 --:--:-- 77.9M

Made a directory in my outputs/ directory specific for this first trinity run. Note, according to the help file, Trinity requires your output directory to include the word “trinity” in it (or else it will make one). 

	[lhs3@mox2 inputs]$ cd ../outputs/
	[lhs3@mox2 outputs]$ mkdir trinity20181029/

I’m using a script that Sam made to run Trinity. I need to provide paths for my run; for example, what is the Trinity program called? The srlab has programs on gscratch, including trinity. I first listed all programs within the srlab programs file to find Trinity. Then, I called the Trinity help file. 

	[lhs3@mox2 scripts]$ ls /gscratch/srlab/programs/
	[lhs3@mox2 scripts]$ /gscratch/srlab/programs/Trinity-v2.8.3/Trinity —help 

I updated Sam’s script with my run info, and saved it in the scripts folder of my repo, called [20181029_olyPS_trinity.sh](https://raw.githubusercontent.com/fish546-2018/laura-quantseq/master/scripts/20181029_olyPS_trinity.sh) 

### Adding programs to path file on Mox 
According to this [github issue]() I need to add programs to my bash path file. I did the following: 

	[lhs3@mox2 ~]$ vi ~/.bashrc
	
Pasted the following, then hit `esc` and `:q` to save and exit `vi`.

	# Custom PATH

	export PATH="$PATH:\
	/gscratch/srlab/programs/bowtie2-2.3.4.1-linux-x86_64:\
	/gscratch/srlab/programs/anaconda3/bin/cutadapt:\
	/gscratch/srlab/programs/FastQC:\
	/gscratch/srlab/programs/jellyfish-2.2.10/bin:\
	/gscratch/srlab/programs/salmon-0.11.2-linux_x86_64/bin:\
	/gscratch/srlab/programs/samtools-1.9"


### Notes about running jobs on Mox: 
  * The gscratch/ folder is where srlab has all its programs stored, and it is huge so allows for large files. When you initially login to mox you are located in a subdirectory, in `/lusr/usr/`. To access gscratch, you must navigate using `cd /gscratch/srlab/`
  * When specifying memory requirements for a job, choose one of the following:  
    * 120G: when you don’t need the maximum amount of memory Mox can provide. This allows our job to run on either of the 2 notes, whichever is available first (can run on the 128G memory node, leaving 8G for other processes).   
    * 500G: when your job is huge, and it requires a TON of memory (leaves 12G of the total 512G for other processes). 

