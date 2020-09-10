#!/bin/bash -euo pipefail
bwa index -a bwtsw genome.fa
mkdir BWAIndex && mv genome.fa* BWAIndex
