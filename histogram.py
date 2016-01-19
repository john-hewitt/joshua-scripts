# Takes a corpus on stdin
# Outputs a JSON dictionary to STDOUT
# Dictionary is {unigrams/bigrams:frequency}
import argparse
import unicodecsv as csv
import codecs
import nltk
import os
import json



# Walk through the bible, updating a dictionary of counts.
def histogram_lang(language_name, bible_untokenized_path):
    histogram = {}
    count = 0
    for line in codecs.open(bible_untokenized_path, 'r', 'utf-8'):
        decoded_line = line
        tokens = decoded_line.split(' ') # Note that tokenization is naive
        for tok in tokens:
            if tok in histogram:
                histogram[tok] = histogram[tok] + 1
            else:
                histogram[tok] = 1
        count += 1
        if count % 10000 == 0:
            print "chewing line %d" % count # give updates on progress to stdout

    # Dump the results into a JSON dictionary
    json.dump(histogram, codecs.open('%s_bible_histogram.json' % language_name, 'w', "utf-8"))




argp = argparse.ArgumentParser()
argp.add_argument('corpus_directory', help ='full path to bible corpora' )

args = argp.parse_args()

for compiled_bible in os.listdir(args.corpus_directory):
    language_name = compiled_bible[-3:]
    bible_path = '/'.join([args.corpus_directory, compiled_bible])
    histogram_lang(language_name, bible_path)
