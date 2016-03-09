#!/bin/bash
set -e
GERRIT_WEBURL=${1:-http://127.0.0.1/gerrit}
LDAP_SERVER=${2:-127.0.0.1}
LDAP_ACCOUNTBASE=${3:-ou=accounts,dc=demo,dc=com}
HTTPD_LISTENURL=${4:-http://*:8080}
GERRIT_NAME=${GERRIT_NAME:-gerrit}
GERRIT_VOLUME=${GERRIT_VOLUME:-gerrit-volume}
PG_GERRIT_NAME=${PG_GERRIT_NAME:-pg-gerrit}
GERRIT_IMAGE_NAME=${GERRIT_IMAGE_NAME:-ci/gerrit}
POSTGRES_IMAGE=${POSTGRES_IMAGE:-postgres}

BASEDIR=$(readlink -f $(dirname $0))
ENTRYPOINT_SCRIPT=${BASEDIR}/http_ldap_config.sh

# Start PostgreSQL.
docker run \
--name ${PG_GERRIT_NAME} \
-P \
-e POSTGRES_USER=gerrit2 \
-e POSTGRES_PASSWORD=gerrit \
-e POSTGRES_DB=reviewdb \
-d ${POSTGRES_IMAGE}

while [ -z "$(docker logs ${PG_GERRIT_NAME} 2>&1 | grep 'autovacuum launcher started')" ]; do
    echo "Waiting postgres ready."
    sleep 1
done

# Create Gerrit volume.
docker run \
--name ${GERRIT_VOLUME} \
${GERRIT_IMAGE_NAME} \
echo "Create Gerrit volume."

# Start Gerrit.
docker run \
--name ${GERRIT_NAME} \
--link ${PG_GERRIT_NAME}:db \
--link ${LDAP_SERVER} \
-p 29418:29418 \
--volumes-from ${GERRIT_VOLUME} \
-v ~/.ssh/id_rsa.pub:/id_rsa.pub \
-e WEBURL=${GERRIT_WEBURL} \
-e HTTPD_LISTENURL=${HTTPD_LISTENURL} \
-e DATABASE_TYPE=postgresql \
-e AUTH_TYPE=HTTP_LDAP \
-e LDAP_SERVER=${LDAP_SERVER} \
-e LDAP_ACCOUNTBASE=${LDAP_ACCOUNTBASE} \
-d ${GERRIT_IMAGE_NAME}

docker cp ${ENTRYPOINT_SCRIPT} ${GERRIT_NAME}:/docker-entrypoint-init.d/
docker restart ${GERRIT_NAME}
