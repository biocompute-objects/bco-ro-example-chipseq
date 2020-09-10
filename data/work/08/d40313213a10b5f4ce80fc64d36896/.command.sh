#!/bin/bash -euo pipefail
cat *.txt > igv_files.txt
igv_files_to_session.py igv_session.xml igv_files.txt ../../genome/genome.fa --path_prefix '../../'
