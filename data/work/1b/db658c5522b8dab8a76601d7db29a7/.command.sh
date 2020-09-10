#!/bin/bash -euo pipefail
bwa mem \
    -t 2 \
    -M \
    -R '@RG\tID:SPT5_T15_R1_T1\tSM:SPT5_T15_R1\tPL:ILLUMINA\tLB:SPT5_T15_R1_T1\tPU:1' \
     \
    BWAIndex/genome.fa \
    SPT5_T15_R1_T1_1_val_1.fq.gz SPT5_T15_R1_T1_2_val_2.fq.gz \
    | samtools view -@ 2 -b -h -F 0x0100 -O BAM -o SPT5_T15_R1_T1.Lb.bam -
