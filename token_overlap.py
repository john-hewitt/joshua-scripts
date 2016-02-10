#! /home/johnhew/doit/bin/python
# Takes a corpus on stdin
# Outputs a JSON dictionary to STDOUT
# Dictionary is {unigrams/bigrams:frequency}
import argparse
import unicodecsv as csv
import codecs
import os
import json
import sys


# fileone, filetwo: dictionaries of the form
# excludefile: dictionary of types that you don't want to count towards the coverage
# (perhaps seen in the training data??????
# word<tab>count
fileone = sys.argv[1]
filetwo = sys.argv[2]
filethree = ''
if len(sys.argv) > 3:
    filethree = sys.argv[3]

# Walk through the bible, updating a dictionary of counts.

# import a previously computed token dictionary from fileone
fileone_dict = {}
for line in codecs.open(fileone, 'r', 'utf-8'):
    word_form, count = line.split('\t')
    fileone_dict[word_form] = int(count)

# import a previously computed dictionary from filetwo
filetwo_dict = {}
filetwo_token_count = 0
for line in codecs.open(filetwo, 'r', 'utf-8'):
    word_form, count = line.split('\t')
    filetwo_dict[word_form] = int(count)
    filetwo_token_count += int(count)

# import a previously computed dictionary
# to exclude from fileone
if filethree:
    for line in codecs.open(filethree):
        word_form, count = line.split('\t')
        fileone_dict.pop(word_form, None)

# compute fileone coverage of filetwo by token and type
type_count = 0
token_count = 0
overlap = {}
for word in filetwo_dict:
    if word in fileone_dict:
        type_count += 1
        token_count += filetwo_dict[word]
        overlap[word] = filetwo_dict[word]

# compute percentages of token and type
type_coverage_percent = float(type_count) / len(filetwo_dict)
token_coverage_percent = float(token_count) / filetwo_token_count


print "Of the {3} types found in {0}, {1} were found in {2}. The coverage percent is {4}".format(filetwo, str(type_count), fileone, len(filetwo_dict), str(type_coverage_percent))
print "Of the {3} tokens found in {0}, {1} were found in {2}. The coverage percent is {4}".format(filetwo, str(token_count), fileone, filetwo_token_count, str(token_coverage_percent))
print "modify this file to print the overlap list"

