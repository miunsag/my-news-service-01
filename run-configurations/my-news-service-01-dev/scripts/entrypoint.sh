#!/bin/bash

echo "Custom entrypoint hook for Microservices Runtime"
echo "Start-time environment is:"
env | sort

# Assure SAG_HOME
SAG_HOME="${SAG_HOME:-/opt/softwareag}"
# Assure LOCAL_PRODUCE_DUMPS
LOCAL_PRODUCE_DUMPS=${LOCAL_PRODUCE_DUMPS:-0}

onInterrupt(){
  echo "Interrupted, shutting down MSR..."
  "${SAG_HOME}/IntegrationServer/bin/shutdown.sh"
}

trap "onInterrupt" SIGINT SIGTERM

d=$(date +%Y-%m-%dT%H.%M.%S_%3N)

# Params
# $1 - snapshot new folder name 
# $2 - snapshot reason
produceHomeSnapshot(){
  if [ "${LOCAL_PRODUCE_DUMPS}" -ne 0 ]; then
    mkdir -p "/mnt/local/s${d}" || return 3
    echo "Producing a snapshot for SAG_HOME in ${1} with reason ${2}"
    pushd .
    cd "${SAG_HOME}" || return 1
    mkdir -p "/mnt/local/s${d}/${1}" || return 2
    tar czf "/mnt/local/s${d}/${1}/SAG_HOME.tgz" .
    popd
  else
    echo "Skipping snapshot for SAG_HOME in ${1} with reason ${2}, LOCAL_PRODUCE_DUMPS = 0"
  fi
}

produceHomeSnapshot "01.beforeStart" "before start" || exit 1

echo "Starting Microservices Runtime"

cd "${SAG_HOME}/IntegrationServer/bin" || exit 2

./server.sh & 
msrPid=$!

portIsReachable(){
    (echo > /dev/tcp/${1}/${2}) >/dev/null 2>&1
    return $?
}

# wait for MSR to come up...

while ! portIsReachable localhost 5555; do
    echo "Waiting for MSR to come up, sleeping 5..."
    sleep 5
done

produceHomeSnapshot "02.afterStart" "after start" || exit 3

wait ${msrPid}

echo "MSR was shut down"

produceHomeSnapshot "03.afterStop" "after stop" || exit 4

echo "Container was shut down"
