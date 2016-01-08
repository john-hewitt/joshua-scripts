#!/bin/bash
# Concatenates a file to itself x times
# USAGE: concatbibles.sh <file> <num_times>

file=$1
num_times=$2
tmp_name=concat_tmp.tmp


echo "Bash version ${BASH_VERSION}..."
for i in {1..20..1}; do
    cat $1 >> concat_tmp.tmp
    echo pizza
done

mv concat_tmp.tmp ./$(basename $1).$num_times
