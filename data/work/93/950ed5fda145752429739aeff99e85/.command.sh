#!/bin/bash -euo pipefail
RUN_SPP=`which run_spp.R`
Rscript -e "library(caTools); source(\"$RUN_SPP\")" -c="SPT5_T0_R1.mLb.clN.sorted.bam" -savp="SPT5_T0_R1.spp.pdf" -savd="SPT5_T0_R1.spp.Rdata" -out="SPT5_T0_R1.spp.out" -p=2
cp spp_correlation_header.txt SPT5_T0_R1_spp_correlation_mqc.tsv
Rscript -e "load('SPT5_T0_R1.spp.Rdata'); write.table(crosscorr\$cross.correlation, file=\"SPT5_T0_R1_spp_correlation_mqc.tsv\", sep=",", quote=FALSE, row.names=FALSE, col.names=FALSE,append=TRUE)"

awk -v OFS='	' '{print "SPT5_T0_R1", $9}' SPT5_T0_R1.spp.out | cat spp_nsc_header.txt - > SPT5_T0_R1_spp_nsc_mqc.tsv
awk -v OFS='	' '{print "SPT5_T0_R1", $10}' SPT5_T0_R1.spp.out | cat spp_rsc_header.txt - > SPT5_T0_R1_spp_rsc_mqc.tsv
