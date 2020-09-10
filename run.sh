#!/bin/sh
set -e
cd data
nextflow run nf-core/chipseq -profile test,conda | tee nextflow.log
