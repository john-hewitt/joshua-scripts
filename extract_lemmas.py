#! /home/johnhew/doit/bin/python
# Takes a Joshua phrase table on stdin
# Takes a Wiktionary parse table on first argument
# MAKE SURE TO UNZIP IT FIRST THROUGH ZCAT
# For every one-to-one pair, it outputs a line in a TSV
# Of the pair mapping, as well as the count of times
# that the pair was seen.
#
# Author : John Hewitt

import sys
import gzip
import pattern.en as pat
import codecs
import unicodecsv as csv
import time


POS_DICT = {'VBD':'VB', 'VBG':'VB', 'VBN':'VB', 'VBP':'VB', 'VBZ':'VB', 'VB':'VB', 'NN':'NN', 'NNS':'NN', 'NNP':'NN', 'NNPS':'NN', 'JJ':'JJ', 'JJR':'JJ', 'JJS':'JJ', 'N':'NN', 'V':'VB', 'ADJ':'JJ'}

'''
Takes a possibly rich POS and returns the base POS
'''
def root(POS):
    if POS in POS_DICT:
        return POS_DICT[POS]
    else:
        return ''

# Create a infleciton-lemma_POS converter from a Wiktionary table
lemma_dict = {} # inflection:[(POS1,lemma1),(POS2,lemma2),...]
try:
    for line_dict in csv.DictReader(open(sys.argv[1], 'r')):
        pos = line_dict['Part of Speech']
        lemma = line_dict['page_url']
        infl = line_dict['cell_value']

        if infl in lemma_dict: 
            lemma_dict[infl].append((pos,lemma))
        else:
            lemma_dict[infl] = [(pos,lemma),]
except IOError as e:
    print >> sys.stderr, "Error in trying to read file, if exists, %s" % sys.argv[1]
    print >> sys.stderr, "exiting in failure..."
    exit(1)

pair_dict = {}

# Iterate through each line of the phrase table
for line in sys.stdin:
    # Split it and assign the source and target sides to variables
    line_array = line.split(' ||| ')
    #print >> sys.stderr, line_array
    source_phrase = line_array[1]
    target_phrase = line_array[2]
    source_tokens = source_phrase.split(' ')
    target_tokens = target_phrase.split(' ')

    # Remove non-terminals first 
    source_tokens = filter(lambda x: x[0] != '[' and x[-1] != ']', source_tokens)
    target_tokens = filter(lambda x: x[0] != '[' and x[-1] != ']', target_tokens)

    # Check for current '1-only' constraint
    if len(source_tokens) != 1 or len(target_tokens) != 1:
        continue

    source_token = source_tokens[0].decode('utf-8')
    target_token = target_tokens[0]
    print >> sys.stderr, (source_token, target_token)

    # Create target parses from CLIPS lab pattern.en, get POS, check NN/VB/JJ
    target_parse_array = pat.parse(target_token, lemmata=True).split('/')
    target_root_POS = root(target_parse_array[1])
   # print >> sys.stderr, source_parse_array
   # print >> sys.stderr, pat.parse(source_token) 
    target_lemma = target_parse_array[4]
    if not target_root_POS:
        continue

    #print >> sys.stderr, target_lemma, target_root_POS

    # Create source parse by looking up in Wiktionary table
    if source_token not in lemma_dict:
        continue
    source_parse_candidates = lemma_dict[source_token]
   # print >> sys.stderr, target_parse_candidates

    # Now, see if any of Wiktionary's candidate parses match with the English
    source_root_POS = ''
    source_lemma = ''
    for pos, lemma in source_parse_candidates:
        if root(pos) == target_root_POS:
            #print >> sys.stderr, target_lemma, target_root_POS
            source_root_POS = root(pos)
            source_lemma = lemma
            break
    if not source_lemma:
        continue

    source_target_string = '\t'.join([source_lemma, source_root_POS, target_lemma,])
   # print >> sys.stderr, source_target_string
    if source_target_string in pair_dict:
        pair_dict[source_target_string] += 1
    else:
        pair_dict[source_target_string] = 1

collection = []
for line in pair_dict:
    #print >> sys.stderr, line, "aaa"
    collection.append([line, pair_dict[line]])

for line in sorted(collection, key=lambda elem: elem[1], reverse=True):
    print line[0].encode('utf-8') +'\t'+ str(line[1])
