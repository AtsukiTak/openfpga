#!/bin/bash

# riscv-tests imageは事前にビルドしておく
docker create --name riscv-tests riscv-tests

docker cp riscv-tests:/opt/riscv/target/share/riscv-tests/isa ./

docker rm riscv-tests
