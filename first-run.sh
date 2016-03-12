#!/bin/bash

echo "Doing first run configuration..."

until $(curl --output /dev/null --silent --head http://localhost:8080/gerrit)
do
    echo "Waiting gerrit ready."
    sleep 1
done

echo "Setup Admin user."
/setupAdminUser.sh

echo "Setup Gerrit-Jenkins connection."
/setupGerritJenkins.sh

echo "Removing scripts."
rm /setupAdminUser.sh
rm /setupGerritJenkins.sh
rm /first-run.sh

echo "First time setup complete"
