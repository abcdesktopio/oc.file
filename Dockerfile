FROM node:current-alpine3.16

COPY /composer  /composer
COPY docker-entrypoint.sh /docker-entrypoint.sh

# Add nodejs file-service and dep

RUN npm install -g yarn && \
    cd /composer/node/common-libraries && yarn install production=true \
    cd /composer/node/file-service     && yarn install production=true

# create default log pid directory
RUN mkdir -p /var/log/desktop /var/run/desktop /composer/run

WORKDIR /
CMD /docker-entrypoint.sh
