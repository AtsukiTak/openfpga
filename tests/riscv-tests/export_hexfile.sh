#!/bin/bash

IMAGE_NAME=riscv-tests
CONTAINER_NAME=riscv-tests

# riscv-tests imageは事前にビルドしておく
docker create --name ${CONTAINER_NAME} ${IMAGE_NAME}

docker cp ${CONTAINER_NAME}:/opt/riscv/target/share/riscv-tests/isa/. generated

docker rm ${CONTAINER_NAME}
