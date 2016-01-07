#!/bin/bash

# This script should take in a directory containing all the phrase tables created through
# the phrase augmentation pipeline. It will spit them out in the correct location
# local to the Joshua experiments to be run. 

# This script should be run in the root of your Joshua experiments directory.

# First argument: langs directory of phrase output
srcdir=$1
# Second argument: index for the experiment...

# For each augmentation model in the langs directory,
for i in $(ls $srcdir/augmentmodel*); do

    # Get the language
    lang=${i: -3:3}

    # Move the file to the correct directory
    echo "moving lang $lang"
    mv $i ./augment_models/

    # Get just the filename of the model
    base=$(basename $i)

    # Now, fix the config file to use the second model. 
    echo "adding config for $lang"
    cp ./inputs/joshua.config ./inputs/joshua.config.$lang

    echo "" >> ./inputs/joshua.config.$lang
    echo "# Second model use addition" >> ./inputs/joshua.config.$lang
    echo "tm = thrax -owner augment -maxspan 20 -path $PWD/augment_models/$base" >> ./inputs/joshua.config.$lang
done

    # Finally, output a bash script to be qsub'd for this
    # Experiment. This is junk as of now. I think it should be done elsewhere. 

    #echo "$JOSHUA/bin/pipeline.pl --rundir 0 --readme "Baseline Hiero Run" --source es --target en --type hiero --corpus $FISHER/corpus/ldc/fisher_train --tune $FISHER/corpus/ldc/fisher_dev --test $FISHER/corpus/ldc/fisher_dev2 --maxlen 10 --lm-order 3"

    #echo "$JOSHUA/bin/pipeline.pl --rundir 0 --readme 'Baseline Run' --source $lang --target en --type hiero --corpus $PWD/data/$lang/trn.bib --tune $PWD/data/$lang/dev.bib --test $





