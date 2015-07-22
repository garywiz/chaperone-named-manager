#!/bin/bash
#Created by chaplocal on Sun Jul 19 19:05:51 AEST 2015
# the cd trick assures this works even if the current directory is not current.
cd ${0%/*}
if [ "$CHAP_SERVICE_NAME" != "" ]; then
  echo You need to run build.sh on your docker host, not inside a container.
  exit
fi
if [ $# != 1 ]; then
  echo "Usage: ./build.sh <production-image-name>"
  exit 1
fi
prodimage="$1"
if [ ! -f build/Dockerfile ]; then
  echo "Expecting to find Dockerfile in ./build ... not found!"
  exit 1
fi
tar czh --exclude '*~' --exclude 'var/*' . | docker build -t $prodimage -f build/Dockerfile -
