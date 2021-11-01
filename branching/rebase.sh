#!/bin/bash
# display command line options

count=1
for param in "$@"; do
<<<<<<< HEAD
    echo "\$@ Parameter #$count = $param"
    count=$(( $count + 1 ))
echo "====="

done
=======
    echo "Parameter: $param"
    count=$(( $count + 1 ))
done

echo "====="
>>>>>>> 1940d32 (git-rebase 1)
