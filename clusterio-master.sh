#!/usr/bin/env bash

docker rm clusterio-master

docker run --name clusterio-master \
  -p 8080:8080 \
  -e USERNAME=furgin \
  -v $(pwd)/config:/config \
  clusterio-master
