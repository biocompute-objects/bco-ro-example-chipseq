#!/bin/bash -euo pipefail
[ ! -f  SPT5_T15_R2_T1_1.fastq.gz ] && ln -s SRR1822158_1.fastq.gz SPT5_T15_R2_T1_1.fastq.gz
[ ! -f  SPT5_T15_R2_T1_2.fastq.gz ] && ln -s SRR1822158_2.fastq.gz SPT5_T15_R2_T1_2.fastq.gz
trim_galore --cores 1 --paired --fastqc --gzip      SPT5_T15_R2_T1_1.fastq.gz SPT5_T15_R2_T1_2.fastq.gz
