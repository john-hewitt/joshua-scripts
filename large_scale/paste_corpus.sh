#!/bin/bash 
# Takes corpus A 
# Takes corpus B
# Pulls a random 1k 10k 20k 50k lines from corpus B
# Pastes them onto corpus A togenerate corpora A_1 A_10 A_20...
# Outputs corpora A_... to distinct files

corpusA_en=$1
corpusA_sr=$2
corpusB_en=$3
corpusB_sr=$4

# Create the random splits and save the split files
paste $corpusA_en $corpusA_sr | shuf | tail - 1000 ~mpost/bin/splittabs en1000 cs1000
paste $corpusA_en $corpusA_sr | shuf | tail - 10000 ~mpost/bin/splittabs en1000 cs1000
paste $corpusA_en $corpusA_sr | shuf | tail - 20000 ~mpost/bin/splittabs en1000 cs1000
paste $corpusA_en $corpusA_sr | shuf | tail - 50000 ~mpost/bin/splittabs en1000 cs1000


# Create the names of the new output files
A1000=$(basename "$corpusB")1000
A10000=$(basename "$corpusB")10000
A20000=$(basename "$corpusB")20000
A50000=$(basename "$corpusB")50000

# Copy the base corpus into its 4 new filenames
cp $corpusB $A1000
cp $corpusB $A10000 
cp $corpusB $A20000
cp $corpusB $A50000

# Concatenate the augmentation corpora onto the base
cat en1000 >> $A1000
cat en10000 >> $A10000
cat en20000 >> $A20000
cat en50000 >> $A50000

#And we're done. 
