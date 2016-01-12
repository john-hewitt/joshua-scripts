#! /home/johnhew/doit/bin/python
'''
Script for treating augmentation phrase table as bitext, and appending it to
training bible data.

Author : John Hewitt johnhew@seas.upenn.edu
'''
import unicodecsv as csv
import sys
import gzip

if len(sys.argv) < 4:
    print 'Usage: augment_bitext.py aug_grammar eng_training for_training'
    exit(1)

aug_file = sys.argv[1]
eng_table = sys.argv[2]
for_table = sys.argv[3]

aug_reader = gzip.open(aug_file)
eng_reader = csv.reader(open(eng_table))
for_reader = csv.reader(open(for_table))
eng_out = csv.writer(open('augmented_bitext.eng', 'w'))
for_out = csv.writer(open('augmented_bitext.for', 'w'))

for i in eng_reader:
    eng_out.writerow(i)

for i in for_reader:
    for_out.writerow(i)


for i in aug_reader:
    line_list = i.split('|||')
    if len(line_list) < 2:
        print line_list, i
    foreign_inf = line_list[1]
    eng_phrase = line_list[2]
    for_out.writerow([foreign_inf])
    eng_out.writerow([eng_phrase])


