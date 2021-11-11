#!/bin/sh

set -xe
rm -rf working
mkdir working
cd working

# Checkout upstream

git clone --depth 1 --branch master https://github.com/docker-library/ruby.git
cd ruby

# Transform

#BASHBREW_SCRIPTS=../.. ./apply-templates.sh

sed -i -e "1 s/FROM.*/FROM ghcr.io\/golden-containers\/buildpack-deps:bullseye/; t" -e "1,// s//FROM ghcr.io\/golden-containers\/buildpack-deps:bullseye/" 3.0/bullseye/Dockerfile

# Build

docker build --tag ghcr.io/golden-containers/ruby:3.0-bullseye 3.0/bullseye

# Push

docker push ghcr.io/golden-containers/ruby -a
