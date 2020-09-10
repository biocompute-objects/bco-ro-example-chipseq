#!/bin/bash -euo pipefail
plot_macs_qc.r \
    -i SPT5_T0_R1_peaks.broadPeak,SPT5_T0_R2_peaks.broadPeak,SPT5_T15_R1_peaks.broadPeak,SPT5_T15_R2_peaks.broadPeak \
    -s SPT5_T0_R1,SPT5_T0_R2,SPT5_T15_R1,SPT5_T15_R2 \
    -o ./ \
    -p macs_peak

plot_homer_annotatepeaks.r \
    -i SPT5_T0_R1_peaks.annotatePeaks.txt,SPT5_T0_R2_peaks.annotatePeaks.txt,SPT5_T15_R1_peaks.annotatePeaks.txt,SPT5_T15_R2_peaks.annotatePeaks.txt \
    -s SPT5_T0_R1,SPT5_T0_R2,SPT5_T15_R1,SPT5_T15_R2 \
    -o ./ \
    -p macs_annotatePeaks

cat peak_annotation_header.txt macs_annotatePeaks.summary.txt > macs_annotatePeaks.summary_mqc.tsv
