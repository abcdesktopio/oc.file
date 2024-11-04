FROM node:alpine3.20
ARG ABCDESKTOP_LOCALACCOUNT_DIR=/etc/localaccount
ENV ABCDESKTOP_LOCALACCOUNT_DIR=$ABCDESKTOP_LOCALACCOUNT_DIR
# default branch
ARG BRANCH=3.3
ENV BRANCH=$BRANCH

RUN apk add --no-cache busybox

# copy file-service repo to /composer/node
RUN apk add --no-cache git && \
    mkdir -p /composer/node/file-service && \
    git clone -b $BRANCH https://github.com/abcdesktopio/file-service.git /composer/node/file-service && \
    apk del --no-cache git 

# Add nodejs file-service and dep
WORKDIR /composer/node/file-service
RUN yarn --production=true

# create default log pid directory
RUN mkdir -p /var/log/desktop /var/run/desktop /composer/run

# start for backward compatibility only
RUN addgroup -g 4096 balloon
RUN adduser -D -u 4096 -G balloon balloon
# end of for backward compatibility only

# change passwd shadow group gshadow
RUN mkdir -p $ABCDESKTOP_LOCALACCOUNT_DIR && \
    for f in passwd shadow group gshadow ; do if [ -f /etc/$f ] ; then  cp /etc/$f $ABCDESKTOP_LOCALACCOUNT_DIR ; rm -f /etc/$f; ln -s $ABCDESKTOP_LOCALACCOUNT_DIR/$f /etc/$f; fi; done

COPY docker-entrypoint.sh /docker-entrypoint.sh
WORKDIR /
CMD /docker-entrypoint.sh
# USER only for backward compatibility only
USER balloon


