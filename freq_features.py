#! /usr/bin/python
# This script takes a Moses phrase table on stdin, and outputs a Moses phrase table.
# Added are binary features that denote the frequency with which the source inflection
# (only works on one-length) have been seen in the training corpus.

# The purpose of this is to provide the tuner (probably kbmira) with a method by which
# to bias against artificial translations when oft-seen phrases have well-estimated 
# translations from the bitext. 
