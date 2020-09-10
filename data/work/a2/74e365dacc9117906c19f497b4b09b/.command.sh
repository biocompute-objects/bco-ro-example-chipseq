#!/bin/bash -euo pipefail
samtools sort -@ 2 -o SPT5_T15_R1_T1.Lb.sorted.bam -T SPT5_T15_R1_T1 SPT5_T15_R1_T1.Lb.bam
samtools index SPT5_T15_R1_T1.Lb.sorted.bam
samtools flagstat SPT5_T15_R1_T1.Lb.sorted.bam > SPT5_T15_R1_T1.Lb.sorted.bam.flagstat
samtools idxstats SPT5_T15_R1_T1.Lb.sorted.bam > SPT5_T15_R1_T1.Lb.sorted.bam.idxstats
samtools stats SPT5_T15_R1_T1.Lb.sorted.bam > SPT5_T15_R1_T1.Lb.sorted.bam.stats
