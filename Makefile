# Load environment variables from .env
include .env
export $(shell sed 's/=.*//' .env)


DOCKER_COMPOSE_COMMAND=docker compose -p jochen

deploy:
	$(DOCKER_COMPOSE_COMMAND)  up -d

setup-rabbitmq:
	@chmod +x ./rabbitmq/rabbitmq_setup.sh  # Ensure the script is executable
	@./rabbitmq/rabbitmq_setup.sh  # Load the .env file and run the script


# RabbitMQ Setup Target
.PHONY: setup-rabbitmq