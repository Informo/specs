#!/bin/bash

# This script checks whether the given number matches the one of an open SCS on
# the Informo specifications repository.
# Exits with code:
#   0: the number matches one of an open SCS
#   1: the number matches a PR with the "deploy" label
#   253: the number matches the one of a closed SCS
#   254: the number doesn't match any existing pull request
#   255: the given parameter isn't a number

get_value() {
	echo $1 | cut -d':' -f2
}

PR_NUMBER=$1

if ! [[ "$PR_NUMBER" =~ ^[0-9]+$ ]]; then
	exit 255
fi

labels=`curl --silent https://api.github.com/repos/Informo/specs/pulls/$PR_NUMBER | jq -r '.labels | .[] | .name' 2> /dev/null`

if [ "$?" != "0" ]; then
	exit 254
fi

scs_type=""
stage=""

for l in $labels; do
	if [[ "$l" == "deploy" ]]; then
		exit 1
	elif [[ $l =~ scsp ]]; then
		stage=`get_value $l`
	elif [[ $l =~ type ]]; then
		scs_type=`get_value $l`
	fi
done

if [ "$scs_type" == "typo" ] || [ "$scs_type" == "behaviour" ]; then
	if [ "$stage" != "merged" ] && [ "$stage" != "won't merge" ]; then
		exit 0
	else
		exit 253
	fi
else
	exit 254
fi
