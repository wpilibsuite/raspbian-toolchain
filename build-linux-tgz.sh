#!/bin/sh

docker pull wpilib/toolchain-builder:14.04$1 \
 && docker run -v ${PWD}:/artifacts wpilib/toolchain-builder:14.04$1 bash -c "\
  cp /artifacts/download.sh /artifacts/repack.sh /artifacts/versions.sh . \
  && cp -R /artifacts/patches /artifacts/linux . \
  && echo 'downloading' && zsh download.sh \
  && zsh repack.sh \
  && cd linux \
  && ./build.sh \
  && cp *.tar.gz /artifacts/"
