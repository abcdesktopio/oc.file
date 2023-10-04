FROM node:alpine3.18

COPY /composer  /composer
COPY docker-entrypoint.sh /docker-entrypoint.sh

# Add nodejs file-service and dep

RUN cd /composer/node/common-libraries && yarn --production=true \
    cd /composer/node/file-service     && yarn --production=true

# create default log pid directory
RUN mkdir -p /var/log/desktop /var/run/desktop /composer/run

WORKDIR /
CMD /docker-entrypoint.sh
