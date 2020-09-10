#!/bin/bash -euo pipefail
computeMatrix scale-regions \
    --regionsFileName genes.bed \
    --scoreFileName SPT5_T0_R2.bigWig \
    --outFileName SPT5_T0_R2.computeMatrix.mat.gz \
    --outFileNameMatrix SPT5_T0_R2.computeMatrix.vals.mat.tab \
    --regionBodyLength 1000 \
    --beforeRegionStartLength 3000 \
    --afterRegionStartLength 3000 \
    --skipZeros \
    --smartLabels \
    --numberOfProcessors 2

plotProfile --matrixFile SPT5_T0_R2.computeMatrix.mat.gz \
    --outFileName SPT5_T0_R2.plotProfile.pdf \
    --outFileNameData SPT5_T0_R2.plotProfile.tab

plotHeatmap --matrixFile SPT5_T0_R2.computeMatrix.mat.gz \
    --outFileName SPT5_T0_R2.plotHeatmap.pdf \
    --outFileNameMatrix SPT5_T0_R2.plotHeatmap.mat.tab
