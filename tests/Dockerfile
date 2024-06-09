FROM ubuntu:24.04

ENV RISCV=/opt/riscv
ENV PATH=$RISCV/bin:$PATH
WORKDIR $RISCV

RUN apt update
RUN apt install -y autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev git
RUN git clone --recursive https://github.com/riscv/riscv-gnu-toolchain

WORKDIR $RISCV/riscv-gnu-toolchain
RUN ./configure --prefix=$RISCV && make

WORKDIR $RISCV
RUN git clone --recursive https://github.com/riscv/riscv-tests

WORKDIR $RISCV/riscv-tests
RUN autoconf && ./configure --prefix=$RISCV/target && make && make install

WORKDIR $RISCV/target/share/riscv-tests/isa
RUN for f in $(ls rv* | grep -v -E ".dump"); do \
      riscv64-unknown-elf-objcopy -O verilog $f $f.hex; \
    done
