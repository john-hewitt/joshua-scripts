#!/bin/bash

# This script takes an evaluation setup that has Bible portions already placed,
# And prepares a second source set, where the bitext is the intelligently interpolated
# bitext made from normal bitext and a phrase table. 

# This script should be run in the root of your Joshua experiments directory.

# First argument: the normalization constant (or the quota, whichever you prefer.)
norm_constant=$1
augment_dir=$2

# Second argument: index for the experiment...

# For each augmentation model in the symlinked augmodel directory,
for aug_model in $(ls $augment_dir/aug* ); do
    augment_lang=${aug_model: -3:3}
    for lang in $(ls data); do
        echo $augment_lang $lang
        # Find the data folder of the language corresponding to the model.
        if [ "$lang" = "$augment_lang" ]; then
            # For each source already present,
            for src in $(ls data/$lang ); do
                echo $augment_lang $lang $src
                # Construct an augmented source that combines the bitext and the phrase table
                # int a new bitext.
                ~/joshua-scripts/weight_tables.py $PWD/data/$lang/$src/trn.eng $PWD/data/$lang/$src/trn.$lang $aug_model $norm_constant
                # This new bitext is currently sitting in the directory in which thie script
                # is run, so put it in its own data folder. Then, when the script creation
                # file is run, it *should* create qsub scripts for the original as well as
                # the augmented bitext. 
                # NOTE: In this case, one probably should ignore the augment scripts, but they may
                # make an interesting comparison. (They are likely done elsewhere.)
                new_folder=$PWD/data/$lang/${src}_aug/
                mkdir $new_folder
                mv ${norm_constant}x_combined_.trn.$lang $new_folder/trn.$lang
                mv ${norm_constant}x_combined_.trn.eng $new_folder/trn.eng

                # Now also copy the same dev data
                cp $PWD/data/$lang/$src/dev.eng $new_folder/dev.eng
                cp $PWD/data/$lang/$src/dev.$lang $new_folder/dev.$lang

                # I'm pretty sure the test data will handle itself (that is, prep_script.sh will handle it.)
            done
        fi
    done
done
