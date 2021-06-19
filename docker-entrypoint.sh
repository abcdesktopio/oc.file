#!/bin/bash

CONTAINER_IP_ADDR=$(hostname -i)
echo "Container local ip addr is $CONTAINER_IP_ADDR"
export CONTAINER_IP_ADDR

# only one process to run
# do not need supervisord
# start command
node /composer/node/file-service/file-service.js

