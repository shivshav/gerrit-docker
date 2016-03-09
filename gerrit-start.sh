#!/bin/bash

set -e

FIRST_RUN=first-run.sh
if [[ -x /$FIRST_RUN ]]; then
     /$FIRST_RUN &
fi

echo "Starting Gerrit..."
exec gosu ${GERRIT_USER} $GERRIT_SITE/bin/gerrit.sh daemon
