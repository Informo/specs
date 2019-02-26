#!/bin/bash

# This script tries to extract the pull request number from CircleCI's
# CIRCLE_PULL_REQUEST environment variable. We can't rely on the
# CIRCLE_PR_NUMBER variable because it's only set when the PR commes from a
# fork, and some SCS are submitted from branches on the specs repo itself. This
# script is pretty simple and doesn't perform any check, so it might not return
# an actual number.

echo $CIRCLE_PULL_REQUEST | rev | cut -d'/' -f1 | rev
