#!/bin/bash

set -e

# === CONFIG ===
IMAGE_NAME="ghcr.io/jv-mk/apache-image"
PLATFORMS="linux/amd64,linux/arm64"
PUSH_LATEST=true

# === VERSION TAG ===
DATE_TAG=$(date +%Y%m%d-%H%M)
GIT_SHA=$(git rev-parse --short HEAD 2>/dev/null || echo "nogit")
VERSION="${DATE_TAG}-${GIT_SHA}"

echo "Building version: $VERSION"
echo "Image: $IMAGE_NAME"

# === BUILDX CHECK ===
if ! docker buildx inspect multiarch-builder >/dev/null 2>&1; then
  echo "Creating buildx builder..."
  docker buildx create --name multiarch-builder --use
  docker buildx inspect --bootstrap
else
  docker buildx use multiarch-builder
fi

# === BUILD & PUSH ===
echo "Building multi-arch image..."
docker buildx build \
  -f Dockerfile \
  --platform $PLATFORMS \
  -t $IMAGE_NAME:$VERSION \
  $( [ "$PUSH_LATEST" = true ] && echo "-t $IMAGE_NAME:latest" ) \
  --push .

echo ""
echo "✅ Done!"
echo "Pushed:"
echo "  $IMAGE_NAME:$VERSION"
if [ "$PUSH_LATEST" = true ]; then
  echo "  $IMAGE_NAME:latest"
fi