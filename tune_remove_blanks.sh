#! /bin/bash
# Removes the blank lines from tuning data so that kbmira doesn't complain

# For each language
for lang in $(ls data/ ); do
    # For each source,
    for src in $(ls data/$lang ); do
        echo $lang/$src
        # for each dev set,
        paste data/$lang/$src/dev.{$lang,eng} | awk -F'\t' '{if ($1 != "") print}' | ~mpost/bin/splittabs data/$lang/$src/dev.noblanks.{$lang,eng}
    done
done
