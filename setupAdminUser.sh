#!/bin/bash
set -x

# Do first time login.
RESPONSE=$(curl -H "X-Remote-User:${GERRIT_ADMIN_UID}" -u ${GERRIT_ADMIN_UID}:${GERRIT_ADMIN_PWD} -X GET http://localhost:8080/gerrit/login 2>/dev/null)
echo "$?"
#[ -z "${RESPONSE}" ] || { echo "${RESPONSE}" ; exit 1; }
