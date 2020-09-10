#!/bin/bash -euo pipefail
preseq lc_extrap \
    -output SPT5_INPUT_R2.ccurve.txt \
    -verbose \
    -bam \
    -pe \
    -seed 1 \
    SPT5_INPUT_R2.mLb.mkD.sorted.bam
cp .command.err SPT5_INPUT_R2.command.log
