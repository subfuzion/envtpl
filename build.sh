#!/bin/bash
#
# This script will build the executable and leave it in this directory.
#
# If the first argument to the script is set to "alpine", then it will
# build a binary for Alpine Linux.
#

IMAGE=$([ "$1" == "alpine" ] && echo "golang:alpine" || echo "golang")
SRCDIR=/usr/local/go/src/github.com/subfuzion/envtpl

docker run --rm -v "$PWD":$SRCDIR -w $SRCDIR $IMAGE go build -v .
