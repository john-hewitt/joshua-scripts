#! /bin/bash
# Complete setup script for a run in Joshua.
#
# USAGE example: ~/joshua-scripts/all_setup.sh tur_swh_fin_ces_noeuro_10-2-16 /export/a09/johnhew/corpora/tur_swh_ces_fin_joshua_formatted/ /home/johnhew/pt_augmentation/phraseaug-01-12-16-max\=5-naiveb\=.5-tur-swh-fin-ces/langs/ 10 2
# Author : John Hewitt : johnhew@seas.upenn.edu
#
#


root_dir=$1
bibles_dir=$2
augment_tables_dir=$3
augment_count=$4
augment_weight=$5

>&2 echo "Building Joshua Experiment Set in $root_dir" 

base=$PWD
#mkdir -p $bibles_dir
#cd /export/a09/johnhew/bible
#./bibbooks.sh
#mv *bib.* $bibles_dir/

cd $base
~/joshua-scripts/prep_root.sh $root_dir
cd $root_dir/data
~/joshua-scripts/setup_bibles.sh $bibles_dir
cd ..
~/joshua-scripts/setup_augments.sh $augment_tables_dir 
~/joshua-scripts/setup_bitext_augments.sh $augment_count $augment_tables_dir $augment_weight
#~/joshua-scripts/setup_augmented_lm.sh $augment_tables_dir
~/joshua-scripts/tune_remove_blanks.sh
~/joshua-scripts/prep_scripts.sh
#~/joshua-scripts/with_augmented_lm/prep_scripts.sh

# Drop the command used to build this experimental run into the run's directory for
# THE FUTURE's benefit

echo "$0 $@" > build_command 
