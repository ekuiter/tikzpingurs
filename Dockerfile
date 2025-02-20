FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    git \
    python3 \
    python3-pip \
    software-properties-common
RUN add-apt-repository ppa:ubuntu-toolchain-r/test \
    && apt-get update && apt-get install -y \
    gcc-9 \
    libstdc++6

WORKDIR /home
RUN git clone https://github.com/rheradio/bdd4va \
    && chmod +x bdd4va/bdd4va/bin/* \
    && for f in bdd4va/bdd4va/bin/*.sh; do sed -i '1s_^_#!/usr/bin/env bash\n_' $f; done \
    && python3 -mpip install ./bdd4va

COPY create_sample.py .
COPY penguin.xml .
ENTRYPOINT ["python3", "create_sample.py"]