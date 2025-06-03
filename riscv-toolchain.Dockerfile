#
# RISC-V Development Dockerfile
#
# Inspired by https://github.com/sbates130272/docker-riscv
#
# This Dockerfile creates a container full of lots of useful tools for
# RISC-V development.

# Pull base image (use Wily for now).
FROM ubuntu:22.04

# Set the maintainer
#MAINTAINER Nicolas Brunie

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Madrid

# Install some base tools that we will need to get the risc-v
# toolchain working.
RUN apt update && apt install -y autoconf automake autotools-dev curl python3 python3-pip python3-tomli libmpc-dev libmpfr-dev \
            libgmp-dev gawk build-essential bison flex texinfo gperf libtool \
            patchutils bc zlib1g-dev libexpat-dev git ninja-build cmake libglib2.0-dev expect \
            device-tree-compiler python3-pyelftools libslirp-dev

# Make a working folder and set the necessary environment variables.
ENV RISCV /opt/riscv
ENV NUMJOBS 1
RUN mkdir -p $RISCV

# Make a directory to download sources and build programs
ENV RISCV_SRCS /home/riscv_srcs/
RUN mkdir -p $RISCV_SRCS

# Add the GNU utils bin folder to the path.
ENV PATH $RISCV/bin:$PATH

# GNU toolchain
WORKDIR $RISCV_SRCS
RUN git clone https://github.com/riscv/riscv-gnu-toolchain
WORKDIR $RISCV_SRCS/riscv-gnu-toolchain
RUN ./configure --prefix=$RISCV --enable-llvm
RUN make -j5
RUN make build-qemu -j5
RUN make stamps/build-spike -j5
RUN make stamps/build-pk64 -j5
RUN make install

# Defaulting to the /home/app directory (where we are going to bind the rvv-examples directory)
WORKDIR /home/app