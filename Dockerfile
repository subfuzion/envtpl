FROM golang:1.11.4
WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o envtpl ./cmd/envtpl/.

FROM scratch
WORKDIR /app
COPY --from=0 /app/envtpl .
ENTRYPOINT [ "./envtpl" ]

