FROM node:alpine3.18

COPY /composer  /composer
COPY docker-entrypoint.sh /docker-entrypoint.sh

# Add nodejs file-service and dep
WORKDIR /composer/node/file-service
RUN yarn --production=true
WORKDIR /composer/node/common-libraries
RUN yarn --production=true

# create default log pid directory
RUN mkdir -p /var/log/desktop /var/run/desktop /composer/run

WORKDIR /
CMD /docker-entrypoint.sh
