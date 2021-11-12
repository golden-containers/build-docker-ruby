#!/bin/bash

set -Eeuxo pipefail
rm -rf working
mkdir working
cd working

# Checkout upstream

git clone --depth 1 --branch master https://github.com/docker-library/ruby.git
cd ruby

# Transform

sed -i -e "1 s/FROM.*/FROM ghcr.io\/golden-containers\/buildpack-deps:bullseye/; t" -e "1,// s//FROM ghcr.io\/golden-containers\/buildpack-deps:bullseye/" 3.0/bullseye/Dockerfile
echo "LABEL ${1:-DEBUG=TRUE}" >> 3.0/bullseye/Dockerfile

sed -i -e "1 s/FROM.*/FROM ghcr.io\/golden-containers\/debian:bullseye-slim/; t" -e "1,// s//FROM ghcr.io\/golden-containers\/debian:bullseye-slim/" 3.0/slim-bullseye/Dockerfile
echo "LABEL ${1:-DEBUG=TRUE}" >> 3.0/slim-bullseye/Dockerfile

# Build

docker build --tag ghcr.io/golden-containers/ruby:3.0-bullseye 3.0/bullseye
docker build --tag ghcr.io/golden-containers/ruby:3.0-slim-bullseye 3.0/slim-bullseye
# Push

docker push ghcr.io/golden-containers/ruby -a
