#!/bin/bash -ex

if [ -n "$DOCKER_TAG" ]; then
    echo "using DOCKER_TAG=$DOCKER_TAG"
else
    PACKAGE_VERSION=$(cat package.json | jq -r '.version')
    echo "package version $PACKAGE_VERSION"
    DOCKER_TAG=$PACKAGE_VERSION
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

# toolchain
pushd toolchain
docker buildx build \
    $BUILDX_ARGS \
    --cache-from nstrumenta/toolchain:buildcache-arm64 \
    --cache-from nstrumenta/toolchain:buildcache-amd64 \
    --platform linux/arm64,linux/amd64 \
    --tag nstrumenta/toolchain:$DOCKER_TAG \
    --tag nstrumenta/toolchain:latest \
    .

# base caches
docker buildx build \
    $BUILDX_ARGS \
    --cache-from nstrumenta/toolchain:buildcache-arm64 \
    --cache-to nstrumenta/toolchain:buildcache-arm64 \
    --platform linux/arm64 \
    --tag nstrumenta/toolchain:buildcache-arm64 \
    .

docker buildx build \
    $BUILDX_ARGS \
    --cache-from nstrumenta/toolchain:buildcache-amd64 \
    --cache-to nstrumenta/toolchain:buildcache-amd64 \
    --platform linux/amd64 \
    --tag nstrumenta/toolchain:buildcache-amd64 \
    .

popd