# Uses Joshua's summarization script to summarize on a much larger scale.
# Run in the root directory
# Pipe summar output to a file if desired

for lang in $(ls runs); do
    for src in $(ls runs/$lang); do
        cd runs/$lang/$src
        echo "Summary for language: $lang and test set: $src"
        $JOSHUA/scripts/training/summarize.pl 
        echo ""
        cd -
    done
done

