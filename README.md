# joshua-scripts
Joshua Decoder Useful Scripts

## What?
These scripts are my main toolbox for setting up large-scale, multi-language, multi-{tune/dev/test}-set Joshua experiment directories. Given a single directory of corpora with the correct naming conventions, these scripts will file away your data,
and even spit out the qsub commands necessary to get a few tens of Joshua runs on their way. When everything has ~~crashed~~ 
completed, then a quick call to summarize_all.sh will even compile together the BLEU scores of your many robust baselines and
helpful augmentations. 

## Why?
Testing end-to-end MT on more than a couple of languages is a huge pain, since the lumbering beasts that are Decoders take 
a lot of pampering to produce a BLEU score (instead of crashing, as they are keen on doing.) Further, the modifications and
augmentation that my work requires (for example, using as second, artificially-constructed grammar for decoding) require even
more finagling. 

## How?
Each one of the scripts here, whether a bash script or python script, is intended to represent some atomic bit of setting
up a well-behaved set of experiment directories. Wherever possible, passing information through stdin via pipes is preferred
to using arguments. 

## Okay, but what if I don't use your silly augmentations? None of this works for me.
Yeah, that's true. Someday that'll no longer be true. For now, use some of the atomic functionality of the individual
scripts.

