#! /home/johnhew/doit/bin/python
# Takes a corpus on stdin
# Outputs a JSON dictionary to STDOUT
# Dictionary is {unigrams/bigrams:frequency}
import unicodecsv as csv
import codecs
import sys


# Walk through the bible, updating a dictionary of counts.

print >>sys.stderr,  "usage: file to histogram on stdin, stdout piped to file"

histogram = {}
count = 0
for line in sys.stdin:
    decoded_line = line
    tokens = decoded_line.split() # Note that tokenization is naive
    for tok in tokens:
        if tok in histogram:
            histogram[tok] = histogram[tok] + 1
        else:
            histogram[tok] = 1
    count += 1
    if count % 10000 == 0:
        print >> sys.stderr, "chewing line %d" % count # give updates on progress to stdout

# Dump the results into a JSON dictionary
for key in sorted(histogram, key= lambda x: histogram[x], reverse=True):
    print key + '\t' + str(histogram[key])


