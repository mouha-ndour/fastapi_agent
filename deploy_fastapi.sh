#!/usr/bin/env bash
set -e

REGION="eu-west-3"
REGISTRY="899469777450.dkr.ecr.${REGION}.amazonaws.com"
REPO="fastapi-app"
IMAGE="${REGISTRY}/${REPO}:latest"

aws ecr get-login-password --region "$REGION" \
| docker login --username AWS --password-stdin "$REGISTRY"

docker pull "$IMAGE"
docker rm -f fastapi || true
docker run -d --restart=always --name fastapi -p 80:8000 "$IMAGE"
