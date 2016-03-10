# Uses Joshua's summarization script to summarize on a much larger scale.
# Run in the root directory
# Pipe summar output to a file if desired

echo ""
for lang in $(ls runs); do
    for src in $(ls runs/$lang); do
        cd runs/$lang/$src
        echo $PWD
        echo "Summary for language: $lang and test set: $src"
        $JOSHUA/scripts/training/summarize.pl 
        cd - > /dev/null
    done
done
echo ""
