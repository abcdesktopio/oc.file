FROM node:current-alpine3.16

COPY /composer  /composer
COPY docker-entrypoint.sh /docker-entrypoint.sh

# Add nodejs service
WORKDIR /composer/node/common-libraries
RUN npm install --production
WORKDIR /composer/node/file-service
RUN npm install --production


# create default log pid directory
RUN mkdir -p 	/var/log/desktop	\
        	/var/run/desktop	\
        	/composer/run
WORKDIR /
CMD /docker-entrypoint.sh
