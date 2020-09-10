#!/bin/bash -euo pipefail
samtools faidx genome.fa
cut -f 1,2 genome.fa.fai > genome.fa.sizes
awk '{print $1, '0' , $2}' OFS='	' genome.fa.sizes > genome.fa.include_regions.bed
