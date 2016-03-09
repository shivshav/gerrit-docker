#!/bin/bash

set -x

# Add ssh-key
cat "${GERRIT_ADMIN_SSHKEY_PATH}" | curl -H X-Remote-User:${GERRIT_ADMIN_UID} --data @- --user "${GERRIT_ADMIN_UID}:${GERRIT_ADMIN_PWD}"  http://localhost:8080/gerrit/a/accounts/self/sshkeys
