#!/bin/bash

set -e

# Dockerfile paths
ANDROID_DOCKERFILE="Android_Dockerfile"
FLET_DOCKERFILE="Flet_Dockerfile"

# Environment variables
TOOLBOX="/root/TOOL"
BUILD_ROOM="/root/buildroom"
AFTER_SHELL="afterbuild.sh"
ENTER_POINT=${1:-$BUILD_ROOM}

# Docker Image tags
ANDROID_TAG="androidbuilder:latest"
FLET_TAG="fletbuilder:latest"

# Copy .bashrc
cp ~/.bashrc TOOL/. || true

# Check path of afterbuild.sh
if [ ! -f "TOOL/${AFTER_SHELL}" ]; then
  echo " TOOL/${AFTER_SHELL} not found. Please ensure it exists."
  exit 1
fi

# Build for Docker images
# This function builds a Docker image from the specified Dockerfile and tags it.
# Arguments: Dockerfile path, Image tag
# The function uses Docker Buildx to build the image for the specified platform (linux/amd64).
# It also passes build arguments for TOOLBOX and AFTER_SHELL to the Dockerfile.
build_image() {
  local dockerfile=$1
  local tag=$2
  echo "Building image: $tag from $dockerfile"
  docker buildx build \
    --file $dockerfile \
    --platform=linux/amd64 \
    --tag $tag \
    --build-arg TOOL=$TOOLBOX \
    --build-arg START_SHELL=$AFTER_SHELL \
    --build-arg AFTER_SHELL=$AFTER_SHELL \
    .
}

# Android Image build
build_image $ANDROID_DOCKERFILE $ANDROID_TAG

# Flet Image build
# This builds the Flet Docker image using the specified Dockerfile and tags it.
build_image $FLET_DOCKERFILE $FLET_TAG

# Run the Android container
# This command runs the Android Docker container interactively, mounting the build room source directory.
# echo "Starting Android container..."
# docker run -it --rm -v ${BUILD_ROOM}/src:/root/src $FLET_TAG bash ${TOOLBOX}/${AFTER_SHELL} ${ENTER_POINT}