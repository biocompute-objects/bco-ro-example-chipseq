#!/bin/bash -euo pipefail
preseq lc_extrap \
    -output SPT5_INPUT_R1.ccurve.txt \
    -verbose \
    -bam \
    -pe \
    -seed 1 \
    SPT5_INPUT_R1.mLb.mkD.sorted.bam
cp .command.err SPT5_INPUT_R1.command.log
