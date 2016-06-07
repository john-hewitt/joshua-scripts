#!/bin/bash

# This script creats qsub-able scripts for all experimental joshua tests based on the 
# Current train/dev/test sets.


# Iterates through the source directories to find all langs to work with.

mkdir qsub_scripts

submit_file=qsub_augments.sh

touch $submit_file
chmod +x $submit_file

#For each language,
for lang in $(ls ./data); do

    # Don't create files to test eng-eng translation...
    if [ "$lang" = "eng" ]; then
        continue
    fi

    # For each test set that we have, (in this order to permit summarization)
    for tst in $(ls ./runs/$lang); do
        # For each source of bitext that we have,
        count=$((10))
        for src in $(ls ./data/$lang); do
            base_target=qsub_scripts/$lang-base_extlm_$tst.$src.$lang.qsub
            augment_target=qsub_scripts/$lang-augment_extlm_$tst.$src.$lang.qsub

            # Add a line that will qsub the two scripts being output.  
            echo "cd $PWD/runs/$lang/$tst/" >> $submit_file
            echo "qsub $PWD/$base_target" >>  $submit_file
            echo "qsub $PWD/$augment_target " >> $submit_file

            # Make a script that runs a non-system test, and increment the run counter
            echo "#$ -o $PWD/runs/$lang/$tst/qsub.o$count" >> $base_target
            echo "#$ -e $PWD/runs/$lang/$tst/qsub.e$count" >> $base_target
            echo "#$ -l 'arch=*64*'" >> $base_target
            echo "#$ -l 'mem_free=10g'" >> $base_target
            echo "#$ -l 'ram_free=10g'" >> $base_target
            echo "#$ -pe smp 15" >> $base_target
            echo "#$ -V" >> $base_target
            echo "#$ -cwd" >> $base_target
            echo "#$ -S /bin/bash" >> $base_target
            echo "$JOSHUA/bin/pipeline.pl --rundir $count --readme 'Augmented LM base Run lang:$lang train:$src test:$tst' --source $lang --target eng --type hiero --corpus $PWD/data/$lang/$src/trn --tune $PWD/data/$lang/$src/dev --test $PWD/runs/$lang/$tst/tst --tuner kbmira --maxlen 80 --lm-order 3 --threads 4 --no-corpus-lm --lmfile ~mpost/expts/gigaword.kenlm.v5 --hadoop-mem 4g --joshua-mem 6g --tmp /export/a11/johnhew/hadoop-tmp/ " >> $base_target
            count=$(($count + 1))


            # Make a script that runs a system-augmented test, and increment the run counter.
            echo "#$ -o $PWD/runs/$lang/$tst/qsub.o$count" >> $augment_target
            echo "#$ -e $PWD/runs/$lang/$tst/qsub.e$count" >> $augment_target
            echo "#$ -l 'arch=*64*'" >> $augment_target
            echo "#$ -l 'mem_free=10g'" >> $augment_target
            echo "#$ -l 'ram_free=10g'" >> $augment_target
            echo "#$ -pe smp 15" >> $augment_target
            echo "#$ -V" >> $augment_target
            echo "#$ -cwd" >> $augment_target
            echo "#$ -S /bin/bash" >> $augment_target
            echo "$JOSHUA/bin/pipeline.pl --rundir $count --readme 'Augmented_LM system run lang:$lang train:$src test:$tst' --source $lang --target eng --type hiero --corpus $PWD/data/$lang/$src/trn --tune $PWD/data/$lang/$src/dev.noblanks --test $PWD/runs/$lang/$tst/tst --maxlen 80 --lm-order 3 --joshua-config $PWD/inputs/joshua.config.$lang" --tuner kbmira --threads 4 --no-corpus-lm --lmfile ~mpost/expts/gigaword.kenlm.v5 --hadoop-mem 4g --joshua-mem 6g --tmp /export/a11/johnhew/hadoop-tmp/ >> $augment_target
            count=$(($count + 1))
        done
    done
done



