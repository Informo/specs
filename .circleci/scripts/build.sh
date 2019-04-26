#!/bin/bash

pr_number=`.circleci/scripts/pr_number.sh`

.circleci/scripts/check_open_scs.sh

if [ "$?" == "1" ]; then
    path_prefix="pr"
else
    path_prefix="scs"
fi

printf "Building %s #%d" $path_prefix $pr_number

hugo -v -b /$path_prefix/$pr_number/ -d workspace/public
