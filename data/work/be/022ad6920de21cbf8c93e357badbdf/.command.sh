#!/bin/bash -euo pipefail
[ ! -f  SPT5_T15_R1_T1_1.fastq.gz ] && ln -s SRR1822157_1.fastq.gz SPT5_T15_R1_T1_1.fastq.gz
[ ! -f  SPT5_T15_R1_T1_2.fastq.gz ] && ln -s SRR1822157_2.fastq.gz SPT5_T15_R1_T1_2.fastq.gz
fastqc -q -t 2 SPT5_T15_R1_T1_1.fastq.gz
fastqc -q -t 2 SPT5_T15_R1_T1_2.fastq.gz
