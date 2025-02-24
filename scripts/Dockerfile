FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    cmake \
    libgmp-dev

WORKDIR /home
RUN git clone https://github.com/ZaydH/spur \
    && git -C spur checkout 58bebca5f4a2c074843d2988fa4707f836c13669 \
    && (cd spur; ./build.sh)