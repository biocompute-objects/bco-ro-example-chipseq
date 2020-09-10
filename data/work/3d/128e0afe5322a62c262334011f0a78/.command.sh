#!/bin/bash -euo pipefail
annotatePeaks.pl \
    SPT5.consensus_peaks.bed \
    genome.fa \
    -gid \
    -gtf genes.gtf \
    -cpu 2 \
    > SPT5.consensus_peaks.annotatePeaks.txt

cut -f2- SPT5.consensus_peaks.annotatePeaks.txt | awk 'NR==1; NR > 1 {print $0 | "sort -T '.' -k1,1 -k2,2n"}' | cut -f6- > tmp.txt
paste SPT5.consensus_peaks.boolean.txt tmp.txt > SPT5.consensus_peaks.boolean.annotatePeaks.txt
