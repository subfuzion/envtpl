FROM golang:1.11.4-alpine
WORKDIR /go/src/github.com/subfuzion/envtpl
COPY . .
RUN go install github.com/subfuzion/envtpl/...

FROM alpine:latest
WORKDIR /usr/local/bin
COPY --from=0 /go/bin/envtpl .
ENTRYPOINT [ "envtpl" ]

