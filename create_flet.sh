#!/bin/bash

set -e

# Dockerfile のパス
ANDROID_DOCKERFILE="Android_Dockerfile"
FLET_DOCKERFILE="Flet_Dockerfile"

# 環境変数とパス
TOOLBOX="/root/TOOL"
BUILD_ROOM="/root/buildroom"
AFTER_SHELL="afterbuild.sh"
ENTER_POINT=${1:-$BUILD_ROOM}

# Docker イメージタグ
ANDROID_TAG="androidbuilder:latest"
FLET_TAG="fletbuilder:latest"

# bashrc のコピー（必要なら）
cp ~/.bashrc TOOL/. || true

# afterbuild.sh の配置確認
if [ ! -f "TOOL/${AFTER_SHELL}" ]; then
  echo " TOOL/${AFTER_SHELL} not found. Please ensure it exists."
  exit 1
fi

# Docker イメージをビルドする関数
# 引数: Dockerfileのパス, イメージタグ
# 例: build_image "Dockerfile" "myimage:latest"
# この関数は、指定されたDockerfileを使用してDockerイメージをビルドします。
# 引数には、Dockerfileのパスとイメージのタグを指定します。
# イメージのビルドには、TOOLBOXとAFTER_SHELLの環境変数を使用します。
# ビルド後、イメージは指定されたタグで保存されます。
build_image() {
  local dockerfile=$1
  local tag=$2
  echo "🔨 Building image: $tag from $dockerfile"
  docker buildx build \
    --file $dockerfile \
    --platform=linux/amd64 \
    --tag $tag \
    --build-arg TOOL=$TOOLBOX \
    --build-arg START_SHELL=$AFTER_SHELL \
    --build-arg AFTER_SHELL=$AFTER_SHELL \
    .
}

# Android イメージのビルド
build_image $ANDROID_DOCKERFILE $ANDROID_TAG

# Flet イメージのビルド
build_image $FLET_DOCKERFILE $FLET_TAG

# コンテナの起動
# echo "Starting Android container..."
# docker run -it --rm -v ${BUILD_ROOM}/src:/root/src $FLET_TAG bash ${TOOLBOX}/${AFTER_SHELL} ${ENTER_POINT}