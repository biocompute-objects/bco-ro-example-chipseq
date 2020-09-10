#!/bin/bash -euo pipefail
picard -Xmx6g MarkDuplicates \
    INPUT=SPT5_T0_R1_T1.Lb.sorted.bam \
    OUTPUT=SPT5_T0_R1.mLb.mkD.sorted.bam \
    ASSUME_SORTED=true \
    REMOVE_DUPLICATES=false \
    METRICS_FILE=SPT5_T0_R1.mLb.mkD.MarkDuplicates.metrics.txt \
    VALIDATION_STRINGENCY=LENIENT \
    TMP_DIR=tmp

samtools index SPT5_T0_R1.mLb.mkD.sorted.bam
samtools idxstats SPT5_T0_R1.mLb.mkD.sorted.bam > SPT5_T0_R1.mLb.mkD.sorted.bam.idxstats
samtools flagstat SPT5_T0_R1.mLb.mkD.sorted.bam > SPT5_T0_R1.mLb.mkD.sorted.bam.flagstat
samtools stats SPT5_T0_R1.mLb.mkD.sorted.bam > SPT5_T0_R1.mLb.mkD.sorted.bam.stats
