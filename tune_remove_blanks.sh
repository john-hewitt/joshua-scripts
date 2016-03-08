#! /bin/bash
# Removes the blank lines from tuning data so that kbmira doesn't complain

# For each language
for lang in $(ls data/ ); do
    # For each source,
    for src in $(ls data/$lang ); do
        # Remember that the English folder holds the original file for the English side of the trn/dev/tst
        # for the other languages. Do not modify it!
        if [ "$lang" = "eng" ]; then
            continue
        fi
        echo $lang/$src
        # for each dev set,
        paste data/$lang/$src/dev.{$lang,eng} | awk -F'\t' '{if ($1 != "") print}' | ~mpost/bin/splittabs data/$lang/$src/dev.noblanks.{$lang,eng}
        rm data/$lang/$src/dev.{$lang,eng}
        ln -s $PWD/data/$lang/$src/dev.noblanks.$lang data/$lang/$src/dev.$lang 
        ln -s $PWD/data/$lang/$src/dev.noblanks.eng data/$lang/$src/dev.eng 
    done
done
