# Because I'm really, really lazy, this script does all the work that even sets up
# A new run directory in a given folder. It makes the symlinks, copies the config files...
# Give it the name of the new directory. It will use this to make the corresponding 
# Directories in the /exports folder too.

dirname=$1

# Make the root directory + normal folders

# Target links for symlinks for ALL directories
# So the sysadmin stops yelling at me.
root=/export/a09/johnhew/joshua_expts/$dirname
runs=/export/a09/johnhew/joshua_expts/$dirname/runs
augments=/export/a09/johnhew/joshua_expts/$dirname/augment_models
inputs=/export/a09/johnhew/joshua_expts/$dirname/inputs
data=/export/a09/johnhew/joshua_expts/$dirname/data

# Create the folders that the symlinks will point to
mkdir -p $root $runs $augments $inputs $data

# Create the symlinks for the non-backed up folders (the runs and the augment files)
ln -s $root $dirname

# Pop in the vanilla config file
cp ~/joshua-scripts/joshua.config $dirname/inputs/
