.PHONY: docker test

docker:
	docker build -t subfuzion/envtpl .

test:
	docker-compose -f docker-compose.test.yml build
	docker-compose -f docker-compose.test.yml run sut
	@docker-compose -f docker-compose.test.yml rm -f >/dev/null 2>&1

