.PHONY: docker test

docker:
	docker build -t subfuzion/envtpl .

test:
	docker-compose -f docker-compose.test.yml build
	docker-compose -f docker-compose.test.yml run --rm sut

