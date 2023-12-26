#!/bin/sh

CONTAINER_IP_ADDR=$(hostname -i)
echo "Container local ip addr is $CONTAINER_IP_ADDR"
export CONTAINER_IP_ADDR

# only one process to run
# do not need supervisord
# to start command
cd /composer/node/file-service
node file-service.js

