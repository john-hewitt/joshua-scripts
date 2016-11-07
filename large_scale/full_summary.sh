#! /bin/bash
# Summarizes one gigantic set of run directories
# As an added bonus, tries to tell if a qsub run has died
# Can do both, or just one or the other

for i in $( ls ); do #Training set
    for j in $( ls $i ); do #Lemma dictionary
        for k in $( ls $i/$j ); do #Morph usage
            for l in $( ls $i/$j/$k ); do #Run
                grep 'FAILED' $i/$j/$k/$l/runs/*/*/* 2> /dev/null
                cd $PWD/$i/$j/$k/$l/
                ~/joshua-scripts/summarize_all.sh
                cd - > /dev/null
            done
        done
    done
done
