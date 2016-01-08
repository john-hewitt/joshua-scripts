#!/bin/bash
# Author : John Hewitt
# Chooses a hard-coded list of books from a hard-coded list of languages
# And spits them out in a target directory, flat.
# Manually set list of suffixes to look for. 

USELANGS=(eus fra hun hye jpn kor)
USESUFFS=(".cs", ".fi", ".tr", ".sw")
#TRAIN="0 |1 |2 |3 |4 |5 |6 |7 |8 |9 |10|11|^12|^13|^14|^15|^16|^17|^18|^19|^20|^21|^22|^23|^24|^25|^26|^27|^28|^29|^30|^31|^32|^33|^34|^35|^36|^37|^38|^39|^40|^41|^42|^43|^44|^45|"
TRAIN="^[^4]|^40|^41|^42|^45|^46|^47|^48|^49"
TEST="^43"
DEV="^44"

ENGPATH=/export/a09/johnhew/bible/parallel/eng-x-bible-newsimplified-v1.txt

# Books to compile into output
# Train=Matthew, Mark Luke
# Dev=Acts
# Test=John
#USEBOOKS=(40, 41, 42)

# Path to all bible data, flat.
BIBLESSPATH=/export/a09/johnhew/bible/parallel/

declare -A SUFFIXES
SUFFIXES[".en"]="english"
SUFFIXES[".cs"]="czech"
SUFFIXES[".fi"]="finnish"
SUFFIXES[".tur"]="turkish"
SUFFIXES[".swh"]="swahili"

for i in "${USELANGS[@]}" 
do
    bool=true
    echo $i
    for f in $(ls -S $BIBLESSPATH$i*);
    do
        if [ "$bool" = true ]; then
        filename=$(basename $f)
            paste versenames.txt $ENGPATH $f | egrep $DEV |  ~mpost/bin/splittabs nums darby.bib.dev.eng $filename.bib.dev.$i
            paste versenames.txt $ENGPATH $f | egrep $TRAIN |  ~mpost/bin/splittabs nums darby.bib.trn.eng $filename.bib.trn.$i
            paste versenames.txt $ENGPATH $f | egrep $TEST |  ~mpost/bin/splittabs nums darby.bib.tst.eng $filename.bib.tst.$i
            bool=false
        fi 
    done
done
