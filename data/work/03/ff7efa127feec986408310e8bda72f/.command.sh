#!/bin/bash -euo pipefail
macs2 callpeak \
    -t SPT5_T0_R1.mLb.clN.sorted.bam \
    -c SPT5_INPUT_R1.mLb.clN.sorted.bam \
    --broad --broad-cutoff 0.1 \
    -f BAMPE \
    -g 1.2E+7 \
    -n SPT5_T0_R1 \
     \
     \
     \
    --keep-dup all

cat SPT5_T0_R1_peaks.broadPeak | wc -l | awk -v OFS='	' '{ print "SPT5_T0_R1", $1 }' | cat peak_count_header.txt - > SPT5_T0_R1_peaks.count_mqc.tsv

READS_IN_PEAKS=$(intersectBed -a SPT5_T0_R1.mLb.clN.sorted.bam -b SPT5_T0_R1_peaks.broadPeak -bed -c -f 0.20 | awk -F '	' '{sum += $NF} END {print sum}')
grep 'mapped (' SPT5_T0_R1.mLb.clN.sorted.bam.flagstat | awk -v a="$READS_IN_PEAKS" -v OFS='	' '{print "SPT5_T0_R1", a/$1}' | cat frip_score_header.txt - > SPT5_T0_R1_peaks.FRiP_mqc.tsv

find * -type f -name "*.broadPeak" -exec echo -e "bwa/mergedLibrary/macs/broadPeak/"{}"\t0,0,178" \; > SPT5_T0_R1_peaks.igv.txt
