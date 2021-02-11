#!/usr/bin/env bash

echo "Starting clusterio slave..."

CONTROL=/config/config-control.json
CONFIG=/config/config-slave.json
SHARED_MODS=/sharedMods
SCENARIOS=/scenarios
OPTS="--config ${CONFIG}"

if [[ ! -e ${CONTROL} ]]; then
  echo "[clusterio-slave] /config/config-control.json not found"
  exit 1;
fi

echo "[clusterio-slave] NAME=${NAME}"

if [[ ! -e ${CONFIG} ]];
then
  echo "[clusterio-slave] creating slave config file..."

  if [[ -z "${NAME}" ]];
  then
    echo "[clusterio-slave] set the slave name using NAME environment variable"
    exit 1;
  fi

  npx clusterioctl slave --config "${CONTROL}" create-config --name "${NAME}" --generate-token --output "${CONFIG}"
fi

npx clusterioslave --config "${CONFIG}" config set slave.instances_directory /config/instances

if [[ -d ${SHARED_MODS} ]];
then
  echo "[clusterio-slave] found /sharedMods, copying to /clusterio/sharedMods..."
  cp /sharedMods/* /clusterio/sharedMods/
else
  echo "[clusterio-slave] mount a volume at /sharedMods to include mods on instances on this slave"
fi

if [[ -d ${SCENARIOS} ]];
then
  echo "[clusterio-slave] found /scenarios/clusterio, copying to /clusterio/scenarios..."
  cp /sharedMods/* /clusterio/sharedMods/
else
  echo "[clusterio-slave] mount a volume at /sharedMods to include mods on instances on this slave"
fi

trap 'echo signal received!; kill "${CHILD_PID}"; wait "${CHILD_PID}"' SIGINT SIGTERM
npx clusterioslave run ${OPTS} &
CHILD_PID="$!"
wait "${CHILD_PID}"
