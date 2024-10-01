#!/bin/sh

apk add --no-cache curl python3 py3-pip
curl -O https://raw.githubusercontent.com/rabbitmq/rabbitmq-server/v3.12.x/deps/rabbitmq_management/bin/rabbitmqadmin
chmod +x rabbitmqadmin
mv rabbitmqadmin /usr/local/bin/

# Declare exchange
rabbitmqadmin --host=rabbitmq --username="$RABBITMQ_DEFAULT_USER" --password="$RABBITMQ_DEFAULT_PASS" declare exchange name="$RABBITMQ_EXCHANGE_NAME" type=direct durable=true

# Create queue
rabbitmqadmin --host=rabbitmq --username="$RABBITMQ_DEFAULT_USER" --password="$RABBITMQ_DEFAULT_PASS" declare queue name="$RABBITMQ_QUEUE_NAME" durable=true

# Create binding
rabbitmqadmin --host=rabbitmq --username="$RABBITMQ_DEFAULT_USER" --password="$RABBITMQ_DEFAULT_PASS" declare binding source="$RABBITMQ_EXCHANGE_NAME" destination="$RABBITMQ_QUEUE_NAME" routing_key="$RABBITMQ_ROUTING_KEY"

tail -f /dev/null
