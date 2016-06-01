# Creates an image that can be used to build an envtpl binary
# that can be copied by another Dockerfile to build a final image that uses it.
FROM golang
RUN apt-get -y update && apt-get -y install git
RUN go get github.com/spf13/cobra
RUN mkdir -p /go/src/github.com/subfuzion/envtpl
VOLUME /go/src/github.com/subfuzion/envtpl
WORKDIR /go/src/github.com/subfuzion/envtpl
CMD ["go", "build", "-v", "."]
