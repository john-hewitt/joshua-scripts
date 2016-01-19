#! /bin/bash

# Takes the path to the original Moses-compatible augmenting grammars
# And augments training data in each of the data folders
# to create an augmented language model

# takes an augmenting grammar and a training set of bitext, and produces a kenlm
# language model with the English side of the phrases, and the English side of the bitext

# 

augment_models=$1

for augment_model in $(ls $augment_models); do
    aug_lang=${augment_model: -3:3}
    for lang in $(ls data); do 
        if [ "$aug_lang" = "$lang" ]; then
            for src in $(ls data/$aug_lang/ ); do
                echo $lang $aug_lang $src 
                ~johnhew/doit/bin/python ~johnhew/joshua-scripts/augment_bitext.py $augment_models/$augment_model  data/$lang/$src/trn.eng data/$lang/$src/trn.$lang
                mv augmented_bitext.eng data/$lang/$src/augmented_bitext.eng
                mv augmented_bitext.for data/$lang/$src/augmented_bitext.$lang
                cat data/$lang/$src/augmented_bitext.eng | $JOSHUA/bin/lmplz -o 3 -S 1G --discount_fallback 1 0 0 > augmentedlm.$lang
                gzip augmentedlm.$lang
                mv augmentedlm.$lang.gz data/$lang/$src/
            done
        fi
    done
done
