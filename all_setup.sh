#! /bin/bash
# Complete setup script for a run in Joshua.
# Usage: all_setup.sh <phrase_table_directory> <bible_directory> <

root_dir=$1
bibles_dir=$2
augment_tables_dir=$3
augment_count=$4
base=$PWD


mkdir -p $bibles_dir
cd /export/a09/johnhew/bible
./bibbooks.sh
mv *bib.* $bibles_dir/

cd $base
~/joshua-scripts/prep_root.sh $root_dir
cd $root_dir/data
~/joshua-scripts/setup_bibles.sh $bibles_dir
cd ..
~/joshua-scripts/setup_augments.sh $augment_tables_dir 
~/joshua-scripts/setup_bitext_augments.sh $augment_count $augment_tables_dir
~/joshua-scripts/setup_augmented_lm.sh 
~/joshua-scripts/tune_remove_blanks.sh
~/joshua-scripts/prep_scripts.sh
~/joshua-scripts/with_augmented_lm/prep_scripts.sh
