FROM node:20
ARG ABCDESKTOP_LOCALACCOUNT_DIR=/etc/localaccount
ENV ABCDESKTOP_LOCALACCOUNT_DIR=$ABCDESKTOP_LOCALACCOUNT_DIR
# default branch
ARG BRANCH=3.3
ENV BRANCH=$BRANCH

# copy file-service repo to /composer/node
RUN mkdir -p /composer/node/file-service && \
    git clone -b $BRANCH https://github.com/abcdesktopio/file-service.git /composer/node/file-service

# Add nodejs file-service and dep
WORKDIR /composer/node/file-service
RUN npm install --save-prod 

# create default log pid directory
RUN mkdir -p /var/log/desktop /var/run/desktop /composer/run

#
# create account balloon for compatility with 2.0
# Next command use $BUSER context
# this is the default user if no user defined
# create group, user, set password
# fix home dir owner
ENV BUSER balloon
RUN groupadd --gid 4096 $BUSER && \
    useradd --create-home --shell /bin/bash --uid 4096 -g $BUSER $BUSER && \
    echo "balloon:lmdpocpetit" | chpasswd $BUSER &&\
    chown -R $BUSER:$BUSER /home/$BUSER

# change passwd shadow group gshadow
RUN mkdir -p $ABCDESKTOP_LOCALACCOUNT_DIR && \
    for f in passwd shadow group gshadow ; do if [ -f /etc/$f ] ; then  cp /etc/$f $ABCDESKTOP_LOCALACCOUNT_DIR ; rm -f /etc/$f; ln -s $ABCDESKTOP_LOCALACCOUNT_DIR/$f /etc/$f; fi; done

# set build date
RUN date > /etc/build.date

COPY docker-entrypoint.sh /docker-entrypoint.sh
WORKDIR /
CMD /docker-entrypoint.sh
# USER only for backward compatibility only
USER balloon


