#!/usr/bin/env bash

echo "Starting clusterio master..."

CONTROL=/config/config-control.json
CONFIG=/config/config-master.json
OPTS="--config ${CONFIG}"

npx clusteriomaster ${OPTS} config set master.database_directory /config/database

if [ ! -z "${EXTERNAL_ADDRESS}" ];
then
  echo "[clusterio-master] setting master.external_address=${EXTERNAL_ADDRESS}"
  npx clusteriomaster config ${OPTS} set master.external_address "${EXTERNAL_ADDRESS}"
else
  echo "[clusterio-master] set EXTERNAL_ADDRESS to force master external address."
fi

if [ ! -e ${CONTROL} ];
then
  if [ -z "${USERNAME}" ]; then
    echo "[clusterio-master] set USERNAME to create config-control.json in config directory."
  else
    echo "[clusterio-master] creating control file for: ${USERNAME}"
    npx clusteriomaster bootstrap ${OPTS} create-admin ${USERNAME}
    npx clusteriomaster bootstrap ${OPTS} create-ctl-config ${USERNAME} --output ${CONTROL}
  fi
fi

trap 'echo signal received!; kill "${CHILD_PID}"; wait "${CHILD_PID}"' SIGINT SIGTERM
npx clusteriomaster run ${OPTS} &
CHILD_PID="$!"
wait "${CHILD_PID}"
