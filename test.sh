#!/bin/bash

COMMIT_SHA=$(git rev-parse --short HEAD)
docker build -t envtpltest:$COMMIT_SHA -f ./Dockerfile.test .
docker run envtpltest:$COMMIT_SHA
