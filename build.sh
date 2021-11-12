#!/bin/bash

set -Eeuxo pipefail
rm -rf working
mkdir working
cd working

# Checkout upstream

git clone --depth 1 --branch master https://github.com/docker-library/ruby.git
cd ruby

# Transform

# This sed syntax is GNU sed specific
[ -z $(command -v gsed) ] && GNU_SED=sed || GNU_SED=gsed

${GNU_SED} -i \
    -e "1 s/FROM.*/FROM ghcr.io\/golden-containers\/buildpack-deps:bullseye/; t" \
    -e "1,// s//FROM ghcr.io\/golden-containers\/buildpack-deps:bullseye/" \
    3.0/bullseye/Dockerfile

${GNU_SED} -i \
    -e "1 s/FROM.*/FROM ghcr.io\/golden-containers\/debian:bullseye-slim/; t" \
    -e "1,// s//FROM ghcr.io\/golden-containers\/debian:bullseye-slim/" \
    3.0/slim-bullseye/Dockerfile

# Build

[ -z "${1:-}" ] && BUILD_LABEL_ARG="" || BUILD_LABEL_ARG=" --label \"${1}\" "

BUILD_PLATFORM=" --platform linux/amd64 "
GCI_URL="ghcr.io/golden-containers"
BUILD_ARGS=" ${BUILD_LABEL_ARG} ${BUILD_PLATFORM} "

docker build 3.0/bullseye/ --tag ${GCI_URL}/ruby:3.0-bullseye ${BUILD_ARGS}
docker build 3.0/slim-bullseye/ --tag ${GCI_URL}/ruby:3.0-slim-bullseye ${BUILD_ARGS}

# Push

docker push ${GCI_URL}/ruby -a
