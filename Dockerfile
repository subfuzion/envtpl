# run "./build.sh alpine" first to generate envtpl
FROM alpine
COPY envtpl .
RUN mv envtpl /usr/local/bin
ENTRYPOINT [ "envtpl" ]

