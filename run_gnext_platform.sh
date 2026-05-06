#!/bin/bash
set -euo pipefail

# Path to the cloned GNExT platform repository
PLATFORM_DIR="/path/to/gnext_platform"

# Path to the study-specific .env file
SOURCE_ENV_FILE="/path/to/your_job/.env"

# Name of the .env file after copying it inside the GNExT platform repository (must to be unique for each study)
ENV_FILE=".env.test1"

# Docker Compose project name. This must be unique for each study to avoid container/network name conflicts
COMPOSE_PROJECT_NAME="gnext_test1"

# Move into platform repo
cd "$PLATFORM_DIR"

# Copy study-specific .env into Docker build context
cp "$SOURCE_ENV_FILE" "$ENV_FILE"

# Check that env file exists in the build context
ls -l "$ENV_FILE"

# Build images
ENV_FILE="$ENV_FILE" COMPOSE_PROJECT_NAME="$COMPOSE_PROJECT_NAME" \
docker compose --env-file "$ENV_FILE" build --no-cache

# Run containers
ENV_FILE="$ENV_FILE" COMPOSE_PROJECT_NAME="$COMPOSE_PROJECT_NAME" \
docker compose --env-file "$ENV_FILE" up -d

echo "[INFO] Waiting for Typesense initialization to complete..."

# Wait for Typesense initialization and automatically restart backend/frontend if the default connection timeout is exceeded
MAX_WAIT=600
WAITED=0

while true; do
  if ENV_FILE="$ENV_FILE" COMPOSE_PROJECT_NAME="$COMPOSE_PROJECT_NAME" \
    docker compose --env-file "$ENV_FILE" logs gnext-backend 2>&1 | grep -q "Starting gunicorn"; then

    echo "[OK] GNExT platform is ready!"
    break
  fi

  if [ "$WAITED" -ge "$MAX_WAIT" ]; then
    echo "[WARN] Timeout reached after ${MAX_WAIT}s."
    echo "[INFO] Restarting backend and frontend..."

    ENV_FILE="$ENV_FILE" COMPOSE_PROJECT_NAME="$COMPOSE_PROJECT_NAME" \
    docker compose --env-file "$ENV_FILE" up -d gnext-backend gnext-frontend

    echo "[INFO] Restart triggered. Waiting again..."
    WAITED=0
  fi

  echo "[INFO] Still importing data into Typesense... (${WAITED}s)"
  sleep 30
  WAITED=$((WAITED + 30))
done