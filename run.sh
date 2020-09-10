#!/bin/sh
nextflow run nf-core/chipseq -profile test,conda | tee nextflow.log
