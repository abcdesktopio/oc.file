FROM node:current-alpine3.16

COPY /composer  /composer
COPY docker-entrypoint.sh /docker-entrypoint.sh

# Add nodejs file-service and dep
RUN cd /composer/node/common-libraries && npm install --omit=dev && &&  npm audit fix \
    cd /composer/node/file-service     && npm install --omit=dev && &&  npm audit fix

# create default log pid directory
RUN mkdir -p 	/var/log/desktop	\
        	/var/run/desktop	\
        	/composer/run
WORKDIR /
CMD /docker-entrypoint.sh
