#!/bin/bash

.circleci/scripts/check_open_scs.sh

if [ "$?" == "1" ]; then
    path_prefix="pr"
else
    path_prefix="scs"
fi

hugo -v -b /$path_prefix/`.circleci/scripts/pr_number.sh`/ -d workspace/public
