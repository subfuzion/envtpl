#!/bin/bash
#
# This script is used to build an image (build-envtpl) which is then used
# to build the envtpl binary for Alpine Linux. The binary can then be copied
# into other images that need to use it.
#
set -e

# build the "builder" image
docker build -t build-envtpl -f build/alpine/Dockerfile .

# run a builder container to create the envtpl binary and save to the
# current directory
docker run --rm -v "$PWD":/usr/local/go/src/github.com/subfuzion/envtpl -w /usr/local/go/src/github.com/subfuzion/envtpl build-envtpl
