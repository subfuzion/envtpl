# Creates an image that can be used to build an envtpl Alpine binary
# that can be copied by another Dockerfile to build a final image that uses it.
FROM golang:alpine
RUN apk update && apk add git
RUN go get github.com/spf13/cobra github.com/Masterminds/sprig
RUN mkdir -p /go/src/github.com/subfuzion/envtpl
VOLUME /go/src/github.com/subfuzion/envtpl
WORKDIR /go/src/github.com/subfuzion/envtpl
CMD ["go", "build", "-v", "."]
