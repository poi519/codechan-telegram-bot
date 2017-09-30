#!/bin/bash

CONTAINER_NAME="s/racket-cirno-bot:0.2"
VER="6.10.1"
URL="http://mirror.racket-lang.org/installers/$VER/racket-minimal-$VER-x86_64-linux.sh" 

if [ "$1" = "" ]
then
  docker build -f Dockerfile -t $CONTAINER_NAME --build-arg RACKET_INSTALLER_URL=$URL --build-arg RACKET_VERSION=$VER .;
elif [ "$1" = "run" ]
then
  docker-compose up
elif [ "$1" = "bash" ]
then
  docker run -i -t  $CONTAINER_NAME /bin/bash
fi
