#!/bin/sh

# Set the alias for the MinIO server
echo "Setting up MinIO Client (mc)..."
if mc alias set myminio $MINIO_HOST $MINIO_ROOT_USER $MINIO_ROOT_PASSWORD; then
  echo "MinIO alias set successfully."
else
  echo "Failed to set MinIO alias."
  exit 1  # Exit the script if alias setting fails
fi

# MinIO Notification Configurations
echo "Setting MinIO notification configurations..."
if mc admin config set myminio notify_amqp:primary \
  url="$RABBITMQ_URL" \
  exchange="$AMQP_EXCHANGE" \
  exchange_type="$AMQP_EXCHANGE_TYPE" \
  routing_key="$AMQP_ROUTING_KEY" \
  mandatory="$AMQP_MANDATORY" \
  durable="$AMQP_DURABLE" \
  no_wait="$AMQP_NO_WAIT" \
  internal="$AMQP_INTERNAL" \
  auto_deleted="$AMQP_AUTO_DELETED" \
  delivery_mode="$AMQP_DELIVERY_MODE"; then
  echo "MinIO notification configurations set successfully."
else
  echo "Failed to set MinIO notification configurations."
  exit 1  # Exit the script if notification config fails
fi

# Restart MinIO service to apply the changes
echo "Restarting MinIO service..."
if mc admin service restart myminio --json; then
  echo "MinIO service restarted successfully."
else
  echo "Failed to restart MinIO service."
  exit 1  # Exit the script if service restart fails
fi

# Create a bucket
echo "Creating bucket $MINIO_BUCKET..."
if mc mb myminio/${MINIO_BUCKET}; then
  echo "Bucket $MINIO_BUCKET created successfully."
else
  echo "Bucket already exists or couldn't be created."
fi

# Add Notification for Bucket
echo "Adding notification for bucket $MINIO_BUCKET..."
if mc event add myminio/${MINIO_BUCKET} arn:minio:sqs::primary:amqp --event put; then
  echo "Notification added for bucket $MINIO_BUCKET successfully."
else
  echo "Failed to add notification for bucket $MINIO_BUCKET."
  exit 1  # Exit the script if notification setup fails
fi

# Print success message
echo "MinIO Client (mc) setup complete!"

# Keep the container running if necessary
tail -f /dev/null
