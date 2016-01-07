#!/bin/bash

# This script creats qsub-able scripts for all experimental joshua tests based on the 
# Current train/dev/test sets.


# Iterates through the source directories to find all langs to work with.

#For each language,
for lang in $(ls ./data); do

    # Don't create files to test eng-eng translation...
    if [ "$lang" = "eng" ]; then
        continue
    fi

    # For each test set that we have, (in this order to permit summarization)
    for tst in $(ls ./runs/$lang); do
        # For each source of bitext that we have,
        count=$((0))
        for src in $(ls ./data/$lang); do
            # Make a script that runs a non-system test, and increment the run counter
            echo "#$ -o $PWD/runs/$lang/$tst/qsub.o$count" >> base_$tst.$src.$lang.qsub
            echo "#$ -e $PWD/runs/$lang/$tst/qsub.e$count" >> base_$tst.$src.$lang.qsub
            echo "#$ -l 'arch=*64*'" >> base_$tst.$src.$lang.qsub
            echo "#$ -V" >> base_$tst.$src.$lang.qsub
            echo "#$ -cwd" >> base_$tst.$src.$lang.qsub
            echo "#$ -S /bin/bash" >> base_$tst.$src.$lang.qsub
            echo "$JOSHUA/bin/pipeline.pl --rundir $count --readme 'Baseline Run lang:$lang train:$src test:$tst' --source $lang --target eng --type hiero --corpus $PWD/data/$lang/$src/trn --tune $PWD/data/$lang/$src/dev --test $PWD/runs/$lang/$tst/tst --maxlen 80 --lm-order 3" >> base_$tst.$src.$lang.qsub
            count=$(($count + 1))

            # Make a script that runs a system-augmented test, and increment the run counter.
            echo "#$ -o $PWD/runs/$lang/$tst/qsub.o$count" >> augment_$tst.$src.$lang.qsub
            echo "#$ -e $PWD/runs/$lang/$tst/qsub.e$count" >> augment_$tst.$src.$lang.qsub
            echo "#$ -l 'arch=*64*'" >> augment_$tst.$src.$lang.qsub
            echo "#$ -V" >> augment_$tst.$src.$lang.qsub
            echo "#$ -cwd" >> augment_$tst.$src.$lang.qsub
            echo "#$ -S /bin/bash" >> augment_$tst.$src.$lang.qsub
            echo "$JOSHUA/bin/pipeline.pl --rundir $count --readme 'System Run lang:$lang train:$src test:$tst' --source $lang --target eng --type hiero --corpus $PWD/data/$lang/$src/trn --tune $PWD/data/$lang/$src/dev --test $PWD/runs/$lang/$tst/tst --maxlen 80 --lm-order 3 --joshua-config $PWD/inputs/joshua.config.$lang" >> augment_$tst.$src.$lang.qsub
            count=$(($count + 1))
        done
    done
done



