#!/bin/bash -euo pipefail
annotatePeaks.pl \
    SPT5_T15_R2_peaks.broadPeak \
    genome.fa \
    -gid \
    -gtf genes.gtf \
    -cpu 2 \
    > SPT5_T15_R2_peaks.annotatePeaks.txt
