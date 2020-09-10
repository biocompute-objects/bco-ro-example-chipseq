#!/bin/bash -euo pipefail
computeMatrix scale-regions \
    --regionsFileName genes.bed \
    --scoreFileName SPT5_INPUT_R1.bigWig \
    --outFileName SPT5_INPUT_R1.computeMatrix.mat.gz \
    --outFileNameMatrix SPT5_INPUT_R1.computeMatrix.vals.mat.tab \
    --regionBodyLength 1000 \
    --beforeRegionStartLength 3000 \
    --afterRegionStartLength 3000 \
    --skipZeros \
    --smartLabels \
    --numberOfProcessors 2

plotProfile --matrixFile SPT5_INPUT_R1.computeMatrix.mat.gz \
    --outFileName SPT5_INPUT_R1.plotProfile.pdf \
    --outFileNameData SPT5_INPUT_R1.plotProfile.tab

plotHeatmap --matrixFile SPT5_INPUT_R1.computeMatrix.mat.gz \
    --outFileName SPT5_INPUT_R1.plotHeatmap.pdf \
    --outFileNameMatrix SPT5_INPUT_R1.plotHeatmap.mat.tab
