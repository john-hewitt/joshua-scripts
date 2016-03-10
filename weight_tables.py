#! /usr/bin/python
# This script creates a bitext from an already-constructed bitext, and a phrase table.
# Given a normalizing constant (say, 20)
# It appends the bitext to itself 20 times
# It then reads the probabilities of the candidates for each source phrase in
# the phrase table, and appends that line the proper number of times for each
# candidate. (i.e. source phrase "dirai" has 2 equal-probability candidates 'will say',
# 'going to say' -- each of the two gets 10 lines.)
#



# Author : John Hewitt

import argparse
import codecs
import math
import sys
import gzip


argp = argparse.ArgumentParser()
argp.add_argument('english', help='path to english side of bitext')
argp.add_argument('foreign', help='path to foreign side of bitext')
argp.add_argument('table', help='path to phrase table')
argp.add_argument('norm', help='normalization constant. (try 20 or 100 or something.')
argp.add_argument('weight', help='integer, weight to give to augmenting phrases')

args = argp.parse_args()

# output goes to two statically named files:
foreign_code = args.foreign[-3:]
source_code = args.foreign[-7:-4]
foreign_out = codecs.open("{0}x_combined_.{1}.{2}".format(args.norm, source_code, foreign_code), 'w', 'utf-8')
english_out = codecs.open("{0}x_combined_.{1}.{2}".format(args.norm, source_code, 'eng'), 'w', 'utf-8')


# Open all the input streams
norm_num = int(args.norm)
weight_num = int(args.weight)
english_stream = codecs.open(args.english, 'r', 'utf-8')
foreign_stream = codecs.open(args.foreign, 'r', 'utf-8')
table_stream = codecs.open(args.table, 'r', 'utf-8')

# First, dump (norm) times of the bitext into the output.

# English bitext (norm) times
for line in english_stream:
    for count in range(0, norm_num):
        english_out.write(line)
# Foreign bitext (norm) times
for line in foreign_stream:
    for count in range(0, norm_num):
        foreign_out.write(line)

# Now, take each source inflection and paste out its candidates up to (norm) times total.
# Take into account the probability for each.
current_source = ''
line_array_buffer = []
norm_num = norm_num * weight_num
for line in table_stream:
    #print line.decode('utf-8')
    line_array = [x.strip() for x in line.split('|||')]
    next_source = line_array[0]

    # Once a new source is found, deal with the set of sources
    # Assign the total quota, and give each phrase the ceiling of its
    # probabilities until the quota is used up. 
    if current_source != next_source:
        quota = norm_num
        for line_array_i in line_array_buffer:
            dir_prob = float(line_array_i[2].split(' ')[2]) #Second value is direct p(e|f)
            count = int(math.ceil(dir_prob * norm_num))
            quota = quota - count
            if quota < 0: # if this count is more than left in the quota, don't write as many
                count = count + quota
            target = line_array_i[1]
            source = line_array_i[0]
            for i in range(0, count):
                english_out.write(target + '\n')
                foreign_out.write(source + '\n')
            #print >> sys.stderr, count, dir_prob # DEBUG TODO

            # Once the quota has been filled, stop writing for this source. 
            if quota <= 0:
                break

        # Empty the line array buffer, set the new current source
        line_array_buffer = []
        # But remember to include the term you've just seen, or it'll get missed.
        line_array_buffer.append(line_array)
        current_source = next_source

    # Else, add to the buffer of lines to be considered in concert. 
    else:
        line_array_buffer.append(line_array)

# The last buffer needs to be flushed, so flush it.
quota = norm_num 
for line_array in line_array_buffer:
    dir_prob = float(line_array[2].split(' ')[2]) #Second value is direct p(e|f)
    count = int(math.ceil(dir_prob * norm_num))
    quota = quota - count
    if quota < 0: # if this count is more than left in the quota, don't write as many
        count = count + quota
    target = line_array[1]
    source = line_array[0]
    for i in range(0, count):
        english_out.write(target + '\n')
        foreign_out.write(source + '\n')
    #print >> sys.stderr, count, dir_prob # DEBUG TODO

    # Once the quota has been filled, stop writing for this source. 
    if quota <= 0:
        break



            







