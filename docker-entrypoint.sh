#!/bin/sh

# Read first $POD_IP if not set get from hostname -i ip address
export CONTAINER_IP_ADDR=${POD_IP:-$(hostname -i)}
echo "Container local ip addr is $CONTAINER_IP_ADDR"

# there is only one process to run
# we do not need to use supervisord
# start command node file-service.js
cd /composer/node/file-service
node file-service.js
