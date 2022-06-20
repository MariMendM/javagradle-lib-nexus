#!/usr/bin/env bash

echo 'WAIT-START: Starting waiting for custom config...'
pwd
while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' host.docker.internal:8081)" != "200" ]]; do echo "."; sleep 10s; done

echo 'WAIT-START: Executing custom config...'
#considering workdir /home/ubuntu:
. ./custom-config/provision.sh

echo 'WAIT-START: Done!'