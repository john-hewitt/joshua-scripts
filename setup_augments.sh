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

    # Get just the filename of the model
    base=$(basename $i)

    # Move the file to the correct directory
    echo "moving lang $lang"
    head $i | ~/joshua_scripts/remove_lex.py | $JOSHUA/scripts/support/moses_phrase_to_joshua.pl | gzip -9n > ./augment_models/$base.gz


    # Now, fix the config file to use the second model. 
    echo "adding config for $lang"
    cp ./inputs/joshua.config ./inputs/joshua.config.$lang

    echo "" >> ./inputs/joshua.config.$lang
    echo "# Second model use addition" >> ./inputs/joshua.config.$lang
    echo "tm = thrax -owner augment -maxspan 20 -path $PWD/augment_models/$base.gz" >> ./inputs/joshua.config.$lang
done
