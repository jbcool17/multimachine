#!/usr/bin/env bash

cd ~/ffmpeg_sources
wget http://downloads.xiph.org/releases/opus/opus-1.1.3.tar.gz
tar xzvf opus-1.1.3.tar.gz
cd opus-1.1.3
./configure --prefix="$HOME/ffmpeg_build" --disable-shared
make
make install
make clean
