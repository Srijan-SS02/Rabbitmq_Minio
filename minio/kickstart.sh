#!/bin/sh

# Set the alias for the MinIO server
echo "Setting up MinIO Client (mc)..."
mc alias set myminio $MINIO_HOST $MINIO_ROOT_USER $MINIO_ROOT_PASSWORD


mc admin config set myminio notify_amqp:primary \
  url="$RABBITMQ_URL" \
  exchange="$AMQP_EXCHANGE" \
  exchange_type="$AMQP_EXCHANGE_TYPE" \
  routing_key="$AMQP_ROUTING_KEY" \
  mandatory="$AMQP_MANDATORY" \
  durable="$AMQP_DURABLE" \
  no_wait="$AMQP_NO_WAIT" \
  internal="$AMQP_INTERNAL" \
  auto_deleted="$AMQP_AUTO_DELETED" \
  delivery_mode="$AMQP_DELIVERY_MODE"

# Restart MinIO service to apply the changes
mc admin service restart myminio

# Create a bucket
mc mb myminio/${MINIO_BUCKET} || echo "Bucket already exists or couldn't be created."

#Add Notification for Bucket
mc event add myminio/${MINIO_BUCKET} arn:minio:sqs::primary:amqp \
  --event put

# Print success message
echo "MinIO Client (mc) setup complete!"

# Keep the container running if necessary
tail -f /dev/null
