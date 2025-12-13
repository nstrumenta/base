#!/bin/bash -ex

if [ -n "$DOCKER_TAG" ]; then
    echo "using DOCKER_TAG=$DOCKER_TAG"
else
    # Use git tag, fallback to 'dev' if no tag exists
    DOCKER_TAG=$(git describe --tags --exact-match 2>/dev/null || echo "dev")
    echo "version from git tag: $DOCKER_TAG"
fi

# login to docker
if [ -n "$DOCKER_HUB_ACCESS_TOKEN" ]; then
    echo "$DOCKER_HUB_ACCESS_TOKEN" | docker login -u "$DOCKER_HUB_USERNAME" --password-stdin
fi

# to push BUILDX_ARGS="--push"
if [ -n "$BUILDX_ARGS" ]; then
    echo "building with BUILDX_ARGS $BUILDX_ARGS"
fi


BUILDX_CONTAINER_NAME=buildx-$DOCKER_TAG
if [[ $(docker buildx inspect $BUILDX_CONTAINER_NAME 2> /dev/null) ]]; then
    echo "using existing $BUILDX_CONTAINER_NAME"
else
    echo "creating $BUILDX_CONTAINER_NAME"
    docker buildx create --name $BUILDX_CONTAINER_NAME --platform linux/arm64,linux/amd64 --driver docker-container --use
fi

# base image
pushd base
docker buildx build \
    $BUILDX_ARGS \
    --cache-from nstrumenta/base:buildcache-arm64 \
    --cache-from nstrumenta/base:buildcache-amd64 \
    --platform linux/arm64,linux/amd64 \
    --tag nstrumenta/base:$DOCKER_TAG \
    --tag nstrumenta/base:latest \
    .

# base caches
docker buildx build \
    $BUILDX_ARGS \
    --cache-from nstrumenta/base:buildcache-arm64 \
    --cache-to nstrumenta/base:buildcache-arm64 \
    --platform linux/arm64 \
    --tag nstrumenta/base:buildcache-arm64 \
    .

docker buildx build \
    $BUILDX_ARGS \
    --cache-from nstrumenta/base:buildcache-amd64 \
    --cache-to nstrumenta/base:buildcache-amd64 \
    --platform linux/amd64 \
    --tag nstrumenta/base:buildcache-amd64 \
    .

popd

# developer image (extends base)
pushd developer
docker buildx build \
    $BUILDX_ARGS \
    --cache-from nstrumenta/developer:buildcache-arm64 \
    --cache-from nstrumenta/developer:buildcache-amd64 \
    --platform linux/arm64,linux/amd64 \
    --tag nstrumenta/developer:$DOCKER_TAG \
    --tag nstrumenta/developer:latest \
    .

# developer caches
docker buildx build \
    $BUILDX_ARGS \
    --cache-from nstrumenta/developer:buildcache-arm64 \
    --cache-to nstrumenta/developer:buildcache-arm64 \
    --platform linux/arm64 \
    --tag nstrumenta/developer:buildcache-arm64 \
    .

docker buildx build \
    $BUILDX_ARGS \
    --cache-from nstrumenta/developer:buildcache-amd64 \
    --cache-to nstrumenta/developer:buildcache-amd64 \
    --platform linux/amd64 \
    --tag nstrumenta/developer:buildcache-amd64 \
    .

popd