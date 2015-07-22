#!/bin/bash
#Created by chaplocal on Mon Jul 13 11:11:00 AEST 2015

IMAGE="chapdev/chaperone-named-manager:latest"
DOCKERHOST=`hostname`

HTTPD_PORT=443
HTTP_PORT=80
BIND_PORT=53

PORTOPT="-p $HTTP_PORT:8080 -p $HTTPD_PORT:8443 -p $BIND_PORT:8053/udp -p $BIND_PORT:8053/tcp"

usage() {
  echo "Usage: run.sh [-d] [-p port#] [-h] [extra-chaperone-options]"
  echo "       Run $IMAGE as a daemon or interactively (the default)."
  echo "       First available port will be remapped to $DOCKERHOST if possible."
  exit
}

cd ${0%/*} # go to directory of this file
APPS=$PWD
cd ..

options="-t -i -e TERM=$TERM --rm=true -e CONFIG_EXT_HTTPD_PORT=$HTTPD_PORT"
shellopt="/bin/bash --rcfile $APPS/bash.bashrc"

while getopts ":-dp:" o; do
  case "$o" in
    d)
      options="-d"
      shellopt=""
      ;;
    p)
      PORTOPT="-p $OPTARG"
      ;;      
    -) # first long option terminates
      break
      ;;
    *)
      usage
      ;;
  esac
done
shift $((OPTIND-1))

# remap ports according to the image, and tell the container about the lowest numbered
# port used.

if [ "$PORTOPT" == "" ]; then
  exposed=`docker inspect $IMAGE | sed -ne 's/^ *"\([0-9]*\)\/tcp".*$/\1/p' - | sort -u`
  if [ "$exposed" != "" -a -x /bin/nc ]; then
    PORTOPT=""
    for PORT in $exposed; do
      if ! /bin/nc -z $DOCKERHOST $PORT; then
	 [ "$PORTOPT" == "" ] && PORTOPT="--env EXTERN_HOSTPORT=$DOCKERHOST:$PORT"
         PORTOPT="$PORTOPT -p $PORT:$PORT"
	 echo "Port $PORT available at $DOCKERHOST:$PORT ..."
      fi
    done
  fi
fi

# Extract our local UID/GID
myuid=`id -u`
mygid=`id -g`

# Run the image with this directory as our local apps dir.
# Create a user with uid=$myuid inside the container so the mountpoint permissions
# are correct.

docker run $options -v /home:/home $PORTOPT $IMAGE \
   --create $USER/$myuid --config $APPS/chaperone.d $* $shellopt
