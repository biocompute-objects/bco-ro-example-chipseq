#!/bin/bash -euo pipefail
featurecounts_deseq2.r \
    --featurecount_file SPT5.consensus_peaks.featureCounts.txt \
    --bam_suffix '.mLb.clN.bam' \
    --outdir ./ \
    --outprefix SPT5.consensus_peaks \
    --outsuffix '' \
    --cores 2 \


sed 's/deseq2_pca/deseq2_pca_1/g' <deseq2_pca_header.txt >tmp.txt
sed -i -e 's/DESeq2 /SPT5 DESeq2 /g' tmp.txt
cat tmp.txt SPT5.consensus_peaks.pca.vals.txt > SPT5.consensus_peaks.pca.vals_mqc.tsv

sed 's/deseq2_clustering/deseq2_clustering_1/g' <deseq2_clustering_header.txt >tmp.txt
sed -i -e 's/DESeq2 /SPT5 DESeq2 /g' tmp.txt
cat tmp.txt SPT5.consensus_peaks.sample.dists.txt > SPT5.consensus_peaks.sample.dists_mqc.tsv

find * -type f -name "*.FDR0.05.results.bed" -exec echo -e "bwa/mergedLibrary/macs/broadPeak/consensus/SPT5/deseq2/"{}"\t255,0,0" \; > SPT5.consensus_peaks.igv.txt
