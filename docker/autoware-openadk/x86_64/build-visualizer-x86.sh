#!/usr/bin/env bash

set -e

SCRIPT_DIR=$(readlink -f "$(dirname "$0")")
WORKSPACE_ROOT="$SCRIPT_DIR/../../../"
source "$WORKSPACE_ROOT/amd64.env"

# https://github.com/docker/buildx/issues/484
export BUILDKIT_STEP_LOG_MAX_SIZE=10000000
export rosdistro

set -x
# Build base images
docker buildx bake --load --progress=plain -f "$SCRIPT_DIR/../docker-bake.hcl" \
    --set "*.context=$WORKSPACE_ROOT" \
    --set "*.ssh=default" \
    --set "*.platform=x86_64" \
    --set "*.args.PLATFORM=x86_64" \
    --set "*.args.ROS_DISTRO=$rosdistro" \
    --set "*.args.BASE_IMAGE=$base_image" \
    --set "base.tags=ghcr.io/autowarefoundation/autoware-openadk:base-$rosdistro-x86_64" \
    --set "devel.tags=ghcr.io/autowarefoundation/autoware-openadk:devel-$rosdistro-x86_64" \
    --set "prebuilt.tags=ghcr.io/autowarefoundation/autoware-openadk:prebuilt-$rosdistro-x86_64"

# Build visualization
docker buildx bake --load --progress=plain -f "$SCRIPT_DIR/../docker-bake.hcl" \
    --set "*.context=$WORKSPACE_ROOT" \
    --set "*.ssh=default" \
    --set "*.platform=x86_64" \
    --set "*.args.PLATFORM=x86_64" \
    --set "*.args.ROS_DISTRO=$rosdistro" \
    --set "*.args.BASE_IMAGE=$base_image" \
    --set "visualizer.tags=ghcr.io/autowarefoundation/autoware-openadk:ces-visualizer-x86_64" \
    visualizer

set +x

#TO-DO
# upload containers via github actions