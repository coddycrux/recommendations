FROM ubuntu:22.04

ENV LANG C.UTF-8

RUN apt-get update \
    && apt-get -y upgrade \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
       python3-matplotlib python3-numpy python3-six python3-yaml \
       libfftw3-3 libyaml-0-2 libtag1v5 libsamplerate0 \
       libavcodec58 libavformat58 libavutil56 libswresample3 libchromaprint1 \
    && rm -rf /var/lib/apt/lists/*

# Build Gaia2
RUN apt-get update && apt-get install -y build-essential git libyaml-dev swig python3-dev pkg-config libeigen3-dev qtdeclarative5-dev && mkdir /gaia && cd /gaia && git clone https://github.com/MTG/gaia.git && cd gaia && python3 waf configure && python3 waf && python3 waf install

RUN apt-get update \
    && apt-get install -y build-essential git python3-dev libeigen3-dev \
    libfftw3-dev libavcodec-dev libavformat-dev libswresample-dev \
    libsamplerate0-dev libtag1-dev libyaml-dev libchromaprint-dev \
    && mkdir /essentia && cd /essentia && git clone https://github.com/MTG/essentia.git \
    && cd /essentia/essentia && python3 waf configure --with-python --with-examples --with-vamp --with-gaia \
    && python3 waf && python3 waf install && ldconfig \
    &&  apt-get remove -y build-essential git libyaml-dev libfftw3-dev libavcodec-dev \
        libavformat-dev libavutil-dev libswresample-dev python-dev libsamplerate0-dev \
        libtag1-dev libeigen3-dev libchromaprint-dev \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && cd / && rm -rf /essentia/essentia


ENV PYTHONPATH /usr/local/lib/python3/dist-packages

WORKDIR /essentia

