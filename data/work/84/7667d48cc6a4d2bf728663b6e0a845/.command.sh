#!/bin/bash -euo pipefail
samtools view \
    -F 0x004 -F 0x0008 -f 0x001 \
    -F 0x0400 \
    -q 1 \
     \
    -b SPT5_T0_R1.mLb.mkD.sorted.bam \
    | bamtools filter \
        -out SPT5_T0_R1.mLb.flT.sorted.bam \
        -script bamtools_filter_pe.json

samtools index SPT5_T0_R1.mLb.flT.sorted.bam
samtools flagstat SPT5_T0_R1.mLb.flT.sorted.bam > SPT5_T0_R1.mLb.flT.sorted.bam.flagstat
samtools idxstats SPT5_T0_R1.mLb.flT.sorted.bam > SPT5_T0_R1.mLb.flT.sorted.bam.idxstats
samtools stats SPT5_T0_R1.mLb.flT.sorted.bam > SPT5_T0_R1.mLb.flT.sorted.bam.stats

samtools sort -n -@ 2 -o SPT5_T0_R1.mLb.flT.bam -T SPT5_T0_R1.mLb.flT SPT5_T0_R1.mLb.flT.sorted.bam
