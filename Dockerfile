FROM node:current-alpine3.16

COPY /composer  /composer
COPY docker-entrypoint.sh /docker-entrypoint.sh

# Add nodejs file-service and dep
RUN cd /composer/node/common-libraries && npm install --omit=dev \
    cd /composer/node/file-service     && npm install --omit=dev

# create default log pid directory
RUN mkdir -p 	/var/log/desktop	\
        	/var/run/desktop	\
        	/composer/run
WORKDIR /
CMD /docker-entrypoint.sh
