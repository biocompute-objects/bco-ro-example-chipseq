#!/bin/bash -euo pipefail
bwa mem \
    -t 2 \
    -M \
    -R '@RG\tID:SPT5_INPUT_R2_T1\tSM:SPT5_INPUT_R2\tPL:ILLUMINA\tLB:SPT5_INPUT_R2_T1\tPU:1' \
     \
    BWAIndex/genome.fa \
    SPT5_INPUT_R2_T1_1_val_1.fq.gz SPT5_INPUT_R2_T1_2_val_2.fq.gz \
    | samtools view -@ 2 -b -h -F 0x0100 -O BAM -o SPT5_INPUT_R2_T1.Lb.bam -
