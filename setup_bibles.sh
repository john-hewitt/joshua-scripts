#!/bin/bash
# Script to take in multiple corpus inputs in multiple languages,
# specified 
# Run this in the data subdirectory of your joshua experiments folder

# For each specified directory, iterate through and create language folders in the data
# Then, within those language folders, create train/dev/test folders, and put the
# files in the right places!

# Files must designate whether they're train/dev/test, and what language they hold
# Languages are in ISO 3-letter codes.2

#Input file name types:
#[trn-dev-tst].[ISO 3-letter].[source].[whatever]
#example: trn.fin.bible.fin-x-bible-1933-v1.txt.fin


# Required directory structure:
#root
#    /inputs
#    /runs
#    /data
#    /augment_models

#${string:position:length}
srcdir=$1


#for i in $(ls -S $srcdir/*); do
#    src=${i: -11:3}
#    if [ "$src" = "eng" ]; then
#        src=${i: -11:3}
#        typ=${i: -7:3}
#        lang=${i: -3:3}
#        base=$(basename $i)

for i in $(ls -S $srcdir/*); do
    # Extract the type of the resource, the language, and the source of it.
    # For some reason, ls $foo/* gives you full filepaths.
    # dunno why. 
    src=${i: -11:3}
    typ=${i: -7:3}
    lang=${i: -3:3}
    echo $typ
    echo $lang
    echo $src
    base=$(basename $i)

    # Put the resource in the correct language data folder
    new_loc=$PWD/$lang/$src/
    mkdir -p $new_loc
    echo $i
    cp $i $new_loc
    ln -s $new_loc/$base ./$lang/$src/$typ.$lang

    # And give a link to the English side.
    ln -s $PWD/eng/$src/$typ.eng ./$lang/$src/$typ.eng

    echo $base


    # In the case of a test set, make the correct folder in the runs directory,
    if [ "$typ" = "tst" ]; then
        # With a link to the test file....
        test_dir=../runs/$lang/$src
        mkdir -p $test_dir
        ln -s $new_loc/tst.$lang $test_dir/tst.$lang 
        echo $new_loc > $test_dir/test_file_name
        # And a link to the English side.
        ln -s $PWD/eng/$src/$typ.eng $test_dir/tst.eng
    fi

done

