# Load environment variables from .env
include .env
export $(shell sed 's/=.*//' .env)


DOCKER_COMPOSE_COMMAND=docker compose -p jochen

deploy:
	$(DOCKER_COMPOSE_COMMAND)  up -d


# RabbitMQ Setup Target
.PHONY: setup-rabbitmq