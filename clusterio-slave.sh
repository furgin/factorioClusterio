#!/usr/bin/env bash

docker rm clusterio-slave

docker run --name clusterio-slave \
  -e NAME=slave1 \
  -v $(pwd)/slave:/config \
  clusterio-slave
