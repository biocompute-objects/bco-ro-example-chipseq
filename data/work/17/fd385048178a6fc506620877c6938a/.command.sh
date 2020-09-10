#!/bin/bash -euo pipefail
plotFingerprint \
    --bamfiles SPT5_T0_R1.mLb.clN.sorted.bam SPT5_INPUT_R1.mLb.clN.sorted.bam \
    --plotFile SPT5_T0_R1.plotFingerprint.pdf \
     \
    --labels SPT5_T0_R1 SPT5_INPUT_R1 \
    --outRawCounts SPT5_T0_R1.plotFingerprint.raw.txt \
    --outQualityMetrics SPT5_T0_R1.plotFingerprint.qcmetrics.txt \
    --skipZeros \
    --JSDsample SPT5_INPUT_R1.mLb.clN.sorted.bam \
    --numberOfProcessors 2 \
    --numberOfSamples 100
