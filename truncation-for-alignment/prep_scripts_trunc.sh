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
        count=$((0))
        for src in $(ls ./data/$lang); do
            base_target=qsub_scripts/$lang-base_kbmira_$tst.$src.$lang.qsub
            augment_target=qsub_scripts/$lang-augment_kbmira_$tst.$src.$lang.qsub

            # Add a line that will qsub the two scripts being output.  
            echo "cd $PWD/runs/$lang/$tst/" >> qsub_all.sh
            echo "qsub $PWD/$base_target " >> qsub_all.sh
            echo "qsub $PWD/$augment_target" >> qsub_all.sh

            # Make a script that runs a non-system test, and increment the run counter
            echo "#$ -o $PWD/runs/$lang/$tst/qsub.o$count" >> $base_target
            echo "#$ -e $PWD/runs/$lang/$tst/qsub.e$count" >> $base_target
            echo "#$ -l 'arch=*64*'" >> $base_target
            echo "#$ -l 'mem_free=25g'" >> $base_target
            echo "#$ -l 'ram_free=25g'" >> $base_target
            echo "#$ -pe smp 15" >> $base_target
            echo "#$ -M john.hewitt64@gmail.com" >> $base_target
            echo "#$ -m eas" >> $base_target
            echo "#$ -V" >> $base_target
            echo "#$ -cwd" >> $base_target
            echo "#$ -S /bin/bash" >> $base_target
            echo "$JOSHUA/bin/pipeline.pl --rundir $count --readme 'Baseline Run lang:$lang train:$src test:$tst' --source $lang --target eng --type hiero --corpus $PWD/data/$lang/$src/trn --tune $PWD/data/$lang/$src/dev --test $PWD/runs/$lang/$tst/tst --tuner kbmira --maxlen 80 --lm-order 3 --threads 4 --hadoop-mem 4g --joshua-mem 6g --tmp /export/a11/johnhew/hadoop-tmp --tokenizer-source /home/johnhew/joshua-scripts/truncenizer.py --last-step ALIGN " >> $base_target
            count=$(($count + 1))

            # Make a script that runs a system-augmented test, and increment the run counter.
            echo "#$ -o $PWD/runs/$lang/$tst/qsub.o$count" >> $augment_target
            echo "#$ -e $PWD/runs/$lang/$tst/qsub.e$count" >> $augment_target
            echo "#$ -l 'arch=*64*'" >> $augment_target
            echo "#$ -l 'mem_free=25g'" >> $augment_target
            echo "#$ -l 'ram_free=25g'" >> $augment_target
            echo "#$ -pe smp 15" >> $augment_target
            echo "#$ -M john.hewitt64@gmail.com" >> $base_target
            echo "#$ -m eas" >> $base_target
            echo "#$ -V" >> $augment_target
            echo "#$ -cwd" >> $augment_target
            echo "#$ -S /bin/bash" >> $augment_target
            echo "$JOSHUA/bin/pipeline.pl --rundir $count --readme 'System Run lang:$lang train:$src test:$tst' --source $lang --target eng --type hiero --corpus $PWD/data/$lang/$src/trn --tune $PWD/data/$lang/$src/dev --test $PWD/runs/$lang/$tst/tst --tuner kbmira --maxlen 80 --lm-order 3 --threads 4 --joshua-config $PWD/inputs/joshua.config.$lang" --hadoop-mem 4g --joshua-mem 6g --tmp /export/a11/johnhew/hadoop-tmp --tokenizer-source /home/johnhew/joshua-scripts/truncenizer.py --last-step ALIGN >> $augment_target
            count=$(($count + 1))
        done
    done
done



