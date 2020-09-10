#!/bin/bash -euo pipefail
featureCounts \
    -F SAF \
    -O \
    --fracOverlap 0.2 \
    -T 2 \
    -p --donotsort \
    -a SPT5.consensus_peaks.saf \
    -o SPT5.consensus_peaks.featureCounts.txt \
    SPT5_T0_R1.mLb.clN.bam SPT5_T15_R2.mLb.clN.bam SPT5_T15_R1.mLb.clN.bam SPT5_T0_R2.mLb.clN.bam
