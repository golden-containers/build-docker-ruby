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

${GNU_SED} -i -e "1 s/FROM.*/FROM ghcr.io\/golden-containers\/buildpack-deps:bullseye/; t" -e "1,// s//FROM ghcr.io\/golden-containers\/buildpack-deps:bullseye/" 3.0/bullseye/Dockerfile

${GNU_SED} -i -e "1 s/FROM.*/FROM ghcr.io\/golden-containers\/debian:bullseye-slim/; t" -e "1,// s//FROM ghcr.io\/golden-containers\/debian:bullseye-slim/" 3.0/slim-bullseye/Dockerfile

# Build

docker build 3.0/bullseye/ --platform linux/amd64 --tag ghcr.io/golden-containers/ruby:3.0-bullseye --label ${1:-DEBUG=TRUE}
docker build 3.0/slim-bullseye/ --platform linux/amd64 --tag ghcr.io/golden-containers/ruby:3.0-slim-bullseye --label ${1:-DEBUG=TRUE}

# Push

docker push ghcr.io/golden-containers/ruby -a
