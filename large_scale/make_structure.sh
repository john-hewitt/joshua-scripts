#!/bin/bash
# Builds a directory structure for marco-level experiment setup
# For Joshua end-to-end MT morphology-ablation study 
# Takes the name for the highest directory as first argument.
#
# Author : John Hewitt johnhew@seas.upenn.edu

full_root='/export/a09/johnhew/joshua_expts/rus_tur/'
#lemma_root='/export/a09/johnhew/lemmatranslation/march16/'
#lemma_wikig_directory='/export/a09/johnhew/lemmatranslation/wiki'
#augment_root='/export/a09/johnhew/augment_models//'
split_root='/export/a09/johnhew/corpora/rus_tur_europarl_tests/split1'

# Here's the overall structure.
# ./
#   -bible
#       --bitext
#           ---morph
#           ---lemmas
#           ---inflections
#       --wikig
#       --both
#   -bible20k
#       --...

# The first level is the training set.
# The second level is the lemma dictionary source
# The third level is the morphology usage


# First, make the root directory. 
mkdir -p $full_root
mkdir -p $lemma_root
mkdir -p $augment_root

# Make a symlink to the place.
ln -s $full_root $1

# Next, make a directory for each training set
for i in $( ls $split_root ); do
    mkdir $full_root$i
done

for i in $( ls $full_root ); do
    # Make the locations for the eventual experimantal runs
#    mkdir -p $full_root$i/bitext/full_morph
#    mkdir -p $full_root$i/bitext/lemmas
#    mkdir -p $full_root$i/bitext/inflections
    mkdir -p $full_root$i/wikig/full_morph
    mkdir -p $full_root$i/wikig/lemmas
    mkdir -p $full_root$i/wikig/inflections
#    mkdir -p $full_root$i/bitext_and_wikig/full_morph
#    mkdir -p $full_root$i/bitext_and_wikig/lemmas
#    mkdir -p $full_root$i/bitext_and_wikig/inflections

    # Make the locations for the eventual lemma dictionaries
  #  mkdir -p $lemma_root$i/bitext/
  #  mkdir -p $lemma_root$i/wikig/
  #  mkdir -p $lemma_root$i/bitext_and_wikig/

  #  # Make the locations for the eventual augmentation models
  #  mkdir -p $augment_root$i/bitext/full_morph
  #  mkdir -p $augment_root$i/bitext/lemmas
  #  mkdir -p $augment_root$i/bitext/inflections
  #  mkdir -p $augment_root$i/wikig/full_morph
  #  mkdir -p $augment_root$i/wikig/lemmas
  #  mkdir -p $augment_root$i/wikig/inflections
  #  mkdir -p $augment_root$i/bitext_and_wikig/full_morph
  #  mkdir -p $augment_root$i/bitext_and_wikig/lemmas
  #  mkdir -p $augment_root$i/bitext_and_wikig/inflections

    # Note that we can only make all of the wikig runs! But we do that.
    # So here, put the wikig resources into the right places
  #  cp $lemma_wikig_directory/* $lemma_root$i/wikig
  #  cp $lemma_wikig_directory/* $lemma_root$i/bitext_and_wikig
done
