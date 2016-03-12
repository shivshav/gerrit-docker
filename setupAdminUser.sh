#!/bin/bash

GERRIT_ADMIN_UID=$OPENLDAP_ENV_CI_ADMIN_UID
GERRIT_ADMIN_PWD=$OPENLDAP_ENV_CI_ADMIN_PWD

# Do first time login.
RESPONSE=$(curl -H "X-Remote-User:${GERRIT_ADMIN_UID}" -u ${GERRIT_ADMIN_UID}:${GERRIT_ADMIN_PWD} -X GET http://localhost:8080/gerrit/login 2>/dev/null)
echo "$?"
#[ -z "${RESPONSE}" ] || { echo "${RESPONSE}" ; exit 1; }
#!/bin/bash

# Add ssh-key
cat "${GERRIT_ADMIN_SSHKEY_PATH}" | curl -H X-Remote-User:${GERRIT_ADMIN_UID} --data @- --user "${GERRIT_ADMIN_UID}:${GERRIT_ADMIN_PWD}"  http://localhost:8080/gerrit/a/accounts/self/sshkeys
