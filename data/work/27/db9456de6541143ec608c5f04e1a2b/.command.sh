#!/bin/bash -euo pipefail
SCALE_FACTOR=$(grep 'mapped (' SPT5_T0_R2.mLb.clN.sorted.bam.flagstat | awk '{print 1000000/$1}')
echo $SCALE_FACTOR > SPT5_T0_R2.scale_factor.txt
genomeCoverageBed -ibam SPT5_T0_R2.mLb.clN.sorted.bam -bg -scale $SCALE_FACTOR -pc  | sort -T '.' -k1,1 -k2,2n >  SPT5_T0_R2.bedGraph

bedGraphToBigWig SPT5_T0_R2.bedGraph genome.fa.sizes SPT5_T0_R2.bigWig

find * -type f -name "*.bigWig" -exec echo -e "bwa/mergedLibrary/bigwig/"{}"\t0,0,178" \; > SPT5_T0_R2.bigWig.igv.txt
