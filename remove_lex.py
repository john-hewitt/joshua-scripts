#!/usr/bin/python
# Removes lexical weights from a Moses phrase table.
# Reads from stdin, prints to stdout

import codecs
import sys

for line in sys.stdin:
    macro_fields = line.split('|||')
    probability_fields = macro_fields[2].split(' ')
    new_prob_str = ' '.join([probability_fields[1], probability_fields[3]])
    macro_fields[2] = new_prob_str
    new_line = '|||'.join(macro_fields)
    print new_line

