#!/bin/bash

pr_number=`.circleci/scripts/pr_number.sh`

.circleci/scripts/check_open_scs.sh $pr_number

ret=$?

echo "script exited with code $ret"

if [ "$ret" == "1" ]; then
    path_prefix="pr"
else
    path_prefix="scs"
fi

printf "Building %s #%d\n" $path_prefix $pr_number

hugo -v -b /$path_prefix/$pr_number/ -d workspace/public
