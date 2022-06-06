all: deploy test

deploy:
	./scripts/deploy.sh

test:
	./scripts/test.sh

delete:
	./scripts/delete.sh