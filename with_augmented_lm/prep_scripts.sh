#!/bin/bash

# This script creats qsub-able scripts for all experimental joshua tests based on the 
# Current train/dev/test sets.


# Iterates through the source directories to find all langs to work with.

mkdir qsub_scripts

touch qsub_all.sh
chmod +x qsub_all.sh

#For each language,
for lang in $(ls ./data); do

    # Don't create files to test eng-eng translation...
    if [ "$lang" = "eng" ]; then
        continue
    fi

    # For each test set that we have, (in this order to permit summarization)
    for tst in $(ls ./runs/$lang); do
        # For each source of bitext that we have,
        count=$((2))
        for src in $(ls ./data/$lang); do
            augment_target=qsub_scripts/$lang-augment_kbmira_agument_lm_$tst.$src.$lang.qsub

            # Add a line that will qsub the two scripts being output.  
            echo "cd $PWD/runs/$lang/$tst/" >> qsub_all.sh
            echo "qsub $PWD/$augment_target" >> qsub_all.sh

            # Make a script that runs a system-augmented test, and increment the run counter.
            echo "#$ -o $PWD/runs/$lang/$tst/qsub.o$count" >> $augment_target
            echo "#$ -e $PWD/runs/$lang/$tst/qsub.e$count" >> $augment_target
            echo "#$ -l 'arch=*64*'" >> $augment_target
            echo "#$ -V" >> $augment_target
            echo "#$ -cwd" >> $augment_target
            echo "#$ -S /bin/bash" >> $augment_target
            echo "$JOSHUA/bin/pipeline.pl --rundir $count --readme 'System Run lang:$lang train:$src test:$tst' --source $lang --target eng --type hiero --corpus $PWD/data/$lang/$src/trn --tune $PWD/data/$lang/$src/dev.noblanks --test $PWD/runs/$lang/$tst/tst --maxlen 80 --lm-order 3 --joshua-config $PWD/inputs/joshua.config.$lang" --tuner kbmira --no-corpus-lm --lmfile $PWD/data/$lang/$src/augmentedlm.$lang.gz >> $augment_target
            count=$(($count + 1))
        done
    done
done


