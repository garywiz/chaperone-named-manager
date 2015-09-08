#!/bin/bash
#Extracted from %(PARENT_IMAGE) on %(`date`)

# Run as interactive: ./%(DEFAULT_LAUNCHER) [options]
#          or daemon: ./%(DEFAULT_LAUNCHER) -d [options]

IMAGE="%(PARENT_IMAGE)"
INTERACTIVE_SHELL="/bin/bash"

#
# NamedManager Application configuration
#

CONFIG_BIND=true		# enable Bind9
CONFIG_MANAGER=true		# enable the web-based configuration manager (also enables Apache/MySQL)

#
# For a secondary nameserver, you should set CONFIG_MANAGER to "false", then set the
# following variable to point to the host where the manager is running.  The port is optional
# and defaults to port 80 if not present.
#

#CONFIG_APIHOST=ns1.namedmanager.com:81

# You can specify the external host and ports for the web server here.  The server always
# runs using SSL, and if you have custom certificates, you will need to match the external
# hostname to the certificates.  By default, self-signed certificates are generated.

EXT_HOSTNAME=%(CONFIG_EXT_HOSTNAME:-localhost)
EXT_HTTP_PORT=%(CONFIG_EXT_HTTP_PORT:-8080)
EXT_HTTPS_PORT=%(CONFIG_EXT_HTTPS_PORT:-8443)
EXT_DNS_PORT=%(CONFIG_EXT_DNS_PORT:-8053)

PORTOPT="-p $EXT_HTTP_PORT:8080 -p $EXT_HTTPS_PORT:8443 -p $EXT_DNS_PORT:8053/tcp -p $EXT_DNS_PORT:8053/udp"

# If this directory exists and is writable, then it will be used
# as attached storage
STORAGE_LOCATION="$PWD/%(IMAGE_BASENAME)-storage"
STORAGE_USER="$USER"

# The rest should be OK...

if [ "$1" == '-d' ]; then
  shift
  docker_opt="-d $PORTOPT"
  INTERACTIVE_SHELL=""
else
  docker_opt="-t -i -e TERM=$TERM --rm=true $PORTOPT"
fi

docker_opt="$docker_opt \
  -e CONFIG_EXT_HOSTNAME=$EXT_HOSTNAME \
  -e CONFIG_EXT_HTTPS_PORT=$EXT_HTTPS_PORT \
  -e CONFIG_EXT_HTTP_PORT=$EXT_HTTP_PORT \
  -e CONFIG_BIND=$CONFIG_BIND \
  -e CONFIG_MANAGER=$CONFIG_MANAGER \
  -e CONFIG_APIHOST=$CONFIG_APIHOST \
"

if [ "$STORAGE_LOCATION" != "" -a -d "$STORAGE_LOCATION" -a -w "$STORAGE_LOCATION" ]; then
  docker_opt="$docker_opt -v $STORAGE_LOCATION:/apps/var"
  chap_opt="--create $STORAGE_USER:/apps/var"
  echo Using attached storage at $STORAGE_LOCATION
fi

docker run $docker_opt $IMAGE $chap_opt $* $INTERACTIVE_SHELL
