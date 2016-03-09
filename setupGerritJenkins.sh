#!/bin/bash

docker exec ssh -i "${SSH_KEY_PATH}" -p 29418 ${GERRIT_ADMIN_UID}@${GERRIT_SSH_HOST} gerrit create-account --group "'Non-Interactive Users'" --full-name "'Jenkins Server'"

#git config
git config user.name  ${GERRIT_ADMIN_UID}
git config user.email ${GERRIT_ADMIN_EMAIL}
git remote add origin ssh://${GERRIT_ADMIN_UID}@${GERRIT_SSH_HOST}:29418/All-Projects 
#checkout project.config
git fetch -q origin refs/meta/config:refs/remotes/origin/meta/config
git checkout meta/config

#add label.Verified
git config -f project.config label.Verified.function MaxWithBlock
git config -f project.config --add label.Verified.defaultValue  0
git config -f project.config --add label.Verified.value "-1 Fails"
git config -f project.config --add label.Verified.value "0 No score"
git config -f project.config --add label.Verified.value "+1 Verified"
##commit and push back
git commit -a -m "Added label - Verified"

#Change global access right
##Remove anonymous access right.
git config -f project.config --unset access.refs/*.read "group Anonymous Users"
##add Jenkins access and verify right
git config -f project.config --add access.refs/heads/*.read "group Non-Interactive Users"
git config -f project.config --add access.refs/tags/*.read "group Non-Interactive Users"
git config -f project.config --add access.refs/heads/*.label-Code-Review "-1..+1 group Non-Interactive Users"
git config -f project.config --add access.refs/heads/*.label-Verified "-1..+1 group Non-Interactive Users"
##add project owners' right to add verify flag
git config -f project.config --add access.refs/heads/*.label-Verified "-1..+1 group Project Owners"
##commit and push back
git commit -a -m "Change access right." -m "Add access right for Jenkins. Remove anonymous access right"
git push origin meta/config:meta/config
