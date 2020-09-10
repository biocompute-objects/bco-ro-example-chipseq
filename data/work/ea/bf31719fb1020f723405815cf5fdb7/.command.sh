#!/bin/bash -euo pipefail
samtools view \
    -F 0x004 -F 0x0008 -f 0x001 \
    -F 0x0400 \
    -q 1 \
     \
    -b SPT5_INPUT_R2.mLb.mkD.sorted.bam \
    | bamtools filter \
        -out SPT5_INPUT_R2.mLb.flT.sorted.bam \
        -script bamtools_filter_pe.json

samtools index SPT5_INPUT_R2.mLb.flT.sorted.bam
samtools flagstat SPT5_INPUT_R2.mLb.flT.sorted.bam > SPT5_INPUT_R2.mLb.flT.sorted.bam.flagstat
samtools idxstats SPT5_INPUT_R2.mLb.flT.sorted.bam > SPT5_INPUT_R2.mLb.flT.sorted.bam.idxstats
samtools stats SPT5_INPUT_R2.mLb.flT.sorted.bam > SPT5_INPUT_R2.mLb.flT.sorted.bam.stats

samtools sort -n -@ 2 -o SPT5_INPUT_R2.mLb.flT.bam -T SPT5_INPUT_R2.mLb.flT SPT5_INPUT_R2.mLb.flT.sorted.bam
