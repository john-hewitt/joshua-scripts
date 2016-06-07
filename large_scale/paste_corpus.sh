#!/bin/bash 
# Takes corpus A 
# Takes corpus B
# Pulls a random 1k 10k 20k 50k lines from corpus B
# Pastes them onto corpus A togenerate corpora A_1 A_10 A_20...
# Outputs corpora A_... to distinct files

corpusAen=$1
corpusAsr=$2
corpusBen=$3
corpusBsr=$4
echo $corpusAen
echo $corpusAsr
echo $corpusBen
echo $corpusBsr

# Create the random splits and save the split files
paste $corpusAen $corpusAsr | shuf | tail -1000 | ~mpost/bin/splittabs en1000 cs1000
#paste $corpusA_en $corpusA_sr | shuf | tail -10000 | ~mpost/bin/splittabs en10000 cs10000
#paste $corpusA_en $corpusA_sr | shuf | tail -20000 | ~mpost/bin/splittabs en20000 cs20000
#paste $corpusA_en $corpusA_sr | shuf | tail -50000 | ~mpost/bin/splittabs en50000 cs50000
#paste $corpusA_en $corpusA_sr | shuf | tail -100000 | ~mpost/bin/splittabs en100000 cs100000
#paste $corpusA_en $corpusA_sr | shuf | tail -10000000 | ~mpost/bin/splittabs en10000000 cs10000000



# Create the names of the new output files
A1000=$(basename "$corpusB" )1000
#A10000=$(basename "$corpusB" )10000
#A20000=$(basename "$corpusB" )20000
#A50000=$(basename "$corpusB" )50000
#A50000=$(basename "$corpusB" )100000
#A50000=$(basename "$corpusB" )10000000

# Copy the base corpus into its 4 new filenames
cp $corpusB $A1000
#cp $corpusB $A10000 
#cp $corpusB $A20000
#cp $corpusB $A50000
#cp $corpusB $A100000
#cp $corpusB $A10000000

# Concatenate the augmentation corpora onto the base
cat en1000 >> $A1000
#cat en10000 >> $A10000
#cat en20000 >> $A20000
#cat en50000 >> $A50000
#cat en50000 >> $A100000
#cat en50000 >> $A10000000

#And we're done. 
