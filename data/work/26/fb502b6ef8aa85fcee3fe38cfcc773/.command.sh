#!/bin/bash -euo pipefail
bampe_rm_orphan.py SPT5_T15_R1.mLb.flT.bam SPT5_T15_R1.mLb.clN.bam --only_fr_pairs

samtools sort -@ 2 -o SPT5_T15_R1.mLb.clN.sorted.bam -T SPT5_T15_R1.mLb.clN SPT5_T15_R1.mLb.clN.bam
samtools index SPT5_T15_R1.mLb.clN.sorted.bam
samtools flagstat SPT5_T15_R1.mLb.clN.sorted.bam > SPT5_T15_R1.mLb.clN.sorted.bam.flagstat
samtools idxstats SPT5_T15_R1.mLb.clN.sorted.bam > SPT5_T15_R1.mLb.clN.sorted.bam.idxstats
samtools stats SPT5_T15_R1.mLb.clN.sorted.bam > SPT5_T15_R1.mLb.clN.sorted.bam.stats
