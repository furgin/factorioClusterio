#!/usr/bin/env bash

set -e

#docker tag clusterio-master registry.furgin.org/furgin/clusterio-master:latest
#docker push registry.furgin.org/furgin/clusterio-master:latest

docker build -t clusterio-base .
docker build -t clusterio-master -f Dockerfile.master .
docker build -t clusterio-slave --no-cache -f Dockerfile.slave .

docker tag clusterio-base registry.furgin.org/furgin/clusterio-base:latest
docker tag clusterio-master registry.furgin.org/furgin/clusterio-master:latest
docker tag clusterio-slave registry.furgin.org/furgin/clusterio-slave:latest

docker push registry.furgin.org/furgin/clusterio-base:latest
docker push registry.furgin.org/furgin/clusterio-master:latest
docker push registry.furgin.org/furgin/clusterio-slave:latest
