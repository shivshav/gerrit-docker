#!/bin/bash
set -x

echo "Doing first run configuration..."

until curl http://localhost:8080/
do
    echo "Waiting gerrit ready."
    sleep 1
done

echo "Setup Admin user."
/addAdminUser.sh

echo "Setup SSH Key."
/addSSHKey.sh

echo "Setup Gerrit-Jenkins connection."
/setupGerritJenkins.sh

echo "Remove scripts."
rm /addAdminUser.sh
rm /addSSHKey.sh
rm /first-run.sh
rm /setupGerritJenkins.sh
