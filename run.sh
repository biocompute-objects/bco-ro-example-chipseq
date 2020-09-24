#!/bin/sh
set -e
cd data
nextflow run nf-core/chipseq -revision 1.2.1 -profile test,conda | tee nextflow.log
