.PHONY: clean docker test

SOURCES := $(shell find . -not \( -path vendor -prune \) -name \*.go -print)

bin/envtpl: $(SOURCES)
	go build -ldflags "-X main.AppVersionMetadata=$$(date -u +%s)" \
		-o bin/envtpl \
		./cmd/envtpl/.

build: bin/envtpl

clean:
	rm -rf bin

image:
	docker build -t subfuzion/envtpl .

test:
	docker-compose -f docker-compose.test.yml build
	docker-compose -f docker-compose.test.yml run --rm sut

