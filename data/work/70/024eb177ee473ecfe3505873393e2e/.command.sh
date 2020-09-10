#!/bin/bash -euo pipefail
plotFingerprint \
    --bamfiles SPT5_T0_R2.mLb.clN.sorted.bam SPT5_INPUT_R2.mLb.clN.sorted.bam \
    --plotFile SPT5_T0_R2.plotFingerprint.pdf \
     \
    --labels SPT5_T0_R2 SPT5_INPUT_R2 \
    --outRawCounts SPT5_T0_R2.plotFingerprint.raw.txt \
    --outQualityMetrics SPT5_T0_R2.plotFingerprint.qcmetrics.txt \
    --skipZeros \
    --JSDsample SPT5_INPUT_R2.mLb.clN.sorted.bam \
    --numberOfProcessors 2 \
    --numberOfSamples 100
