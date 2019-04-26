#!/bin/bash

deploy() {
	ssh http@it-01.informo.network mkdir -p /srv/http/specs/public/$1/$2 2>&1 > /dev/null
	scp -r /tmp/workspace/public/* http@it-01.informo.network:/srv/http/specs/public/$1/$2/
}

PR_NUMBER=`/tmp/workspace/scripts/pr_number.sh`

/tmp/workspace/scripts/check_open_scs.sh $PR_NUMBER

ret=$?

if [ "$ret" == "0" ]; then
	deploy "scs" $PR_NUMBER
elif [ "$ret" == "1" ]; then
	deploy "pr" $PR_NUMBER
else
	echo "This is not an open SCS, aborting deployment"
fi
