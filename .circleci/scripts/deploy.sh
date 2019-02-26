#!/bin/bash

PR_NUMBER=`/tmp/workspace/scripts/pr_number.sh`

/tmp/workspace/scripts/check_open_scs.sh $PR_NUMBER

if [ "$?" == "0" ]; then
	ssh http@it-01.informo.network mkdir -p /srv/http/specs/public/scs/$PR_NUMBER 2>&1 > /dev/null
	scp -r /tmp/workspace/public/* http@it-01.informo.network:/srv/http/specs/public/scs/$PR_NUMBER/
else
	echo "This is not an open SCS, aborting deployment"
fi
