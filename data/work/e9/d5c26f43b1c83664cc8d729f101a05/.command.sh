#!/bin/bash -euo pipefail
sort -T '.' -k1,1 -k2,2n SPT5_T0_R1_peaks.broadPeak SPT5_T0_R2_peaks.broadPeak SPT5_T15_R1_peaks.broadPeak SPT5_T15_R2_peaks.broadPeak \
    | mergeBed -c 2,3,4,5,6,7,8,9 -o collapse,collapse,collapse,collapse,collapse,collapse,collapse,collapse > SPT5.consensus_peaks.txt

macs2_merged_expand.py SPT5.consensus_peaks.txt \
    SPT5_T0_R1,SPT5_T0_R2,SPT5_T15_R1,SPT5_T15_R2 \
    SPT5.consensus_peaks.boolean.txt \
    --min_replicates 1 \


awk -v FS='	' -v OFS='	' 'FNR > 1 { print $1, $2, $3, $4, "0", "+" }' SPT5.consensus_peaks.boolean.txt > SPT5.consensus_peaks.bed

echo -e "GeneID	Chr	Start	End	Strand" > SPT5.consensus_peaks.saf
awk -v FS='	' -v OFS='	' 'FNR > 1 { print $4, $1, $2, $3,  "+" }' SPT5.consensus_peaks.boolean.txt >> SPT5.consensus_peaks.saf

plot_peak_intersect.r -i SPT5.consensus_peaks.boolean.intersect.txt -o SPT5.consensus_peaks.boolean.intersect.plot.pdf

find * -type f -name "SPT5.consensus_peaks.bed" -exec echo -e "bwa/mergedLibrary/macs/broadPeak/consensus/SPT5/"{}"\t0,0,0" \; > SPT5.consensus_peaks.bed.igv.txt
