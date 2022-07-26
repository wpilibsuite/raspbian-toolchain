#!/bin/bash

# Grab .deb files from http://archive.raspbian.org/raspbian/pool/main/
# and then run /path/to/install-pkg.sh *.deb

export BASEDIR=`dirname $0`

# Extract data to basedir
for var in "$@"
do
ar p "$var" data.tar.xz | sh -c "cd ${BASEDIR} && tar xJf -"
done

pushd ${BASEDIR}

# move the arm-linux-gnueabihf libs to just the base "lib"
sh -c 'cd lib && ln -s arm-linux-gnueabihf/* .'
sh -c 'cd usr/lib/debug && ln -s ../arm-linux-gnueabihf/debug/* .'
sh -c 'cd usr/lib && ln -s arm-linux-gnueabihf/* .'

# change absolute symlinks into relative symlinks
find . -lname '/*' | \
while read l ; do
  echo ln -sf $(echo $(echo $l | sed 's|/[^/]*|/..|g')$(readlink $l) | sed 's/.....//') $l
done | \
sh

popd
