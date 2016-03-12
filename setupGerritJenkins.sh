#!/bin/bash
GERRIT_ADMIN_EMAIL=${OPENLDAP_ENV_CI_ADMIN_EMAIL}
CONFIG_WORKDIR=All-Projects

# Clone from repo on disk
mkdir $CONFIG_WORKDIR
cd $CONFIG_WORKDIR

git init
#checkout project.config
git fetch -q origin refs/meta/config:refs/remotes/origin/meta/config
git checkout meta/config

# Setup committer username and email
git config user.name  ${GERRIT_ADMIN_UID}
git config user.email ${GERRIT_ADMIN_EMAIL}

#add label.Verified
git config -f project.config label.Verified.function MaxWithBlock
git config -f project.config --add label.Verified.defaultValue  0
git config -f project.config --add label.Verified.value "-1 Fails"
git config -f project.config --add label.Verified.value "0 No score"
git config -f project.config --add label.Verified.value "+1 Verified"
##commit and push back
git commit --quiet -a -m "Added label - Verified"

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
git commit --quiet -a -m "Change access right." -m "Add access right for Jenkins. Remove anonymous access right"
git push origin meta/config:meta/config

cd ..
rm -rf $CONFIG_WORKDIR
