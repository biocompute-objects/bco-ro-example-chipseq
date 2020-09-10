#!/bin/bash -euo pipefail
bampe_rm_orphan.py SPT5_INPUT_R2.mLb.flT.bam SPT5_INPUT_R2.mLb.clN.bam --only_fr_pairs

samtools sort -@ 2 -o SPT5_INPUT_R2.mLb.clN.sorted.bam -T SPT5_INPUT_R2.mLb.clN SPT5_INPUT_R2.mLb.clN.bam
samtools index SPT5_INPUT_R2.mLb.clN.sorted.bam
samtools flagstat SPT5_INPUT_R2.mLb.clN.sorted.bam > SPT5_INPUT_R2.mLb.clN.sorted.bam.flagstat
samtools idxstats SPT5_INPUT_R2.mLb.clN.sorted.bam > SPT5_INPUT_R2.mLb.clN.sorted.bam.idxstats
samtools stats SPT5_INPUT_R2.mLb.clN.sorted.bam > SPT5_INPUT_R2.mLb.clN.sorted.bam.stats
