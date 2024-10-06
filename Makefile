# Load environment variables from .env

DOCKER_COMPOSE_COMMAND=docker compose

deploy:
	$(DOCKER_COMPOSE_COMMAND)  up -d ${services}

stop:
	$(DOCKER_COMPOSE_COMMAND)  stop ${services}

down:
	$(DOCKER_COMPOSE_COMMAND)  down ${services}

pull:
	$(DOCKER_COMPOSE_COMMAND) pull ${services}


build:
	$(DOCKER_COMPOSE_COMMAND) build ${services} 


# RabbitMQ Setup Target
.PHONY: setup-rabbitmq