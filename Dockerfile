# defaul TAG is dev
ARG TAG=dev
# Default release is 18.04
ARG BASE_IMAGE_RELEASE=18.04
# Default base image 
ARG BASE_IMAGE=ubuntu:18.04

# --- BEGIN node_modules_builder ---
FROM $BASE_IMAGE as node_modules_builder

#Install curl
RUN apt-get update && apt-get install -y --no-install-recommends \
      software-properties-common    \
	    gnupg                         \
	    gpg-agent                     \
      curl                          \
    && apt-get clean                \
    && rm -rf /var/lib/apt/lists/*

# this package nodejs include npm 
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - \ 
	&& apt-get update 				\
	&& apt-get install -y --no-install-recommends	\
        	nodejs					\
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*


#Install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y --no-install-recommends \
          yarn \
  && apt-get clean                    \
  && rm -rf /var/lib/apt/lists/*

COPY composer /composer

# Add nodejs service
WORKDIR /composer/node/common-libraries
RUN   yarn install

WORKDIR /composer/node/file-service
RUN yarn install 

# --- START Build image ---
FROM $BASE_IMAGE

# Add LABELS
LABEL MAINTAINER="Alexandre DEVELY"
LABEL vcs-type "git"
LABEL vcs-url  "https://github.com/abcdesktopio/oc.file"
LABEL vcs-ref  "master"
LABEL release  "5"
LABEL version  "1.2"
LABEL architecture "x86_64"


# define env
ENV DEBCONF_FRONTEND noninteractive
ENV TERM linux



# apt install iproute2 install ip command
# install supervisor
RUN apt-get update && apt-get install -y  --no-install-recommends      \
	    curl			\
	    gpg-agent			\
      software-properties-common 	\
	    gnupg			\
  && apt-get clean			\
	&& rm -rf /var/lib/apt/lists/*	



# this package nodejs include npm 
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - \ 
    &&  apt-get update && 				\
	apt-get install -y --no-install-recommends	\
        	nodejs					\
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY --from=node_modules_builder /composer  /composer

COPY docker-entrypoint.sh /docker-entrypoint.sh

# Next command use $BUSER context
ENV BUSER balloon
# RUN adduser --disabled-password --gecos '' $BUSER
# RUN id -u $BUSER &>/dev/null || 
RUN groupadd --gid 4096 $BUSER
RUN useradd --create-home --shell /bin/bash --uid 4096 -g $BUSER --groups $BUSER
# create an ubuntu user
# PASS=`pwgen -c -n -1 10`
# PASS=ballon
# Change password for user balloon
RUN echo "balloon:lmdpocpetit" | chpasswd $BUSER
#

RUN echo `date` > /etc/build.date

# LOG AND PID SECTION
RUN mkdir -p 	/var/log/desktop	\
        	/var/run/desktop	\
        	/composer/run

CMD /docker-entrypoint.sh



