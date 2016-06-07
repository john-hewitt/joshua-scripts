#! /usr/bin/python2
#
# Truncation tokenizer. Tokenizes with a supplied penn-treebank-tokenizer   
#
# Author : John Hewitt : johnhew@seas.upenn.edu
#
#

import os
import sys
from subprocess import Popen
from StringIO import StringIO
from subprocess import PIPE
import tempfile

# Specify the truncation length for a corpus.
trunclength = 6

# Check for a Joshua install
if not os.environ.get('JOSHUA'):
    print >> sys.stderr, "Set up the Joshua environment var."
    exit(1)

# Point to Joshua's tokenizer
joshua = os.environ.get('JOSHUA')
tokenizer = '/'.join([joshua, 'scripts'
    ,'training', 'penn-treebank-tokenizer.perl'])

# Send the corpus to the tokenizer
proc = Popen(tokenizer, stdin=PIPE, stdout=PIPE)
stdout, stderr = proc.communicate(input=sys.stdin.read())

# Take the tokenized corpus, truncate each word, and 
# send on to stdout
for line in stdout.split('\n')[:-1]:
    line = line.decode('utf-8')
    words = [x[:trunclength] for x in line.split(' ')]
    print ' '.join(words).encode('utf-8')
