#!/bin/bash
GERRIT_NAME=${GERRIT_NAME:-gerrit}
GERRIT_VOLUME=${GERRIT_VOLUME:-gerrit-volume}
PG_GERRIT_NAME=${PG_GERRIT_NAME:-pg-gerrit}

echo "Removing ${GERRIT_NAME}..."
docker stop ${GERRIT_NAME} &> /dev/null
docker rm -v ${GERRIT_NAME} &> /dev/null

echo "Removing ${GERRIT_VOLUME}..."
docker rm -v ${GERRIT_VOLUME} &> /dev/null

echo "Removing ${PG_GERRIT_NAME}..."
docker stop ${PG_GERRIT_NAME} &> /dev/null
docker rm -v ${PG_GERRIT_NAME} &> /dev/null
