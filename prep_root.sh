# Because I'm really, really lazy, this script does all the work that even sets up
# A new run directory in a given folder. It makes the symlinks, copies the config files...
# Give it the name of the new directory. It will use this to make the corresponding 
# Directories in the /exports folder too.

dirname=$1

# Make the root directory + normal folders
mkdir $dirname
cd $dirname
mkdir inputs
mkdir data

# Create the non-backed up folders for the symlinks
runs=/export/a09/johnhew/joshua_expts/$dirname
augments=/export/a09/johnhew/augment_models/$dirname
mkdir $runs
mkdir $augments

# Create the symlinks for the non-backed up folders (the runs and the augment files)
ln -s $runs runs
ln -s $augments augment_models

# Pop in the vanilla config file
cp ~/joshua-scripts/joshua.config inputs/
