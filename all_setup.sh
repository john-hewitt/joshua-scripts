#! /bin/bash
# Complete setup script for a run in Joshua.
# Usage: all_setup.sh <phrase_table_directory> <bible_directory>

root_dir=$1
bibles_dir=$2
augment_tables_dir=$3

~/johnhew/joshua-scripts/prep_root.sh $root_dir
cd $root_dir/data
~/johnhew/joshua-scripts/setup_bibles.sh $bibles_dir
