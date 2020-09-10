#!/bin/bash -euo pipefail
picard -Xmx6g CollectMultipleMetrics \
    INPUT=SPT5_T0_R1.mLb.clN.sorted.bam \
    OUTPUT=SPT5_T0_R1.mLb.clN.CollectMultipleMetrics \
    REFERENCE_SEQUENCE=genome.fa \
    VALIDATION_STRINGENCY=LENIENT \
    TMP_DIR=tmp
