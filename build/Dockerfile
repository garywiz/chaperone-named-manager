FROM chapdev/chaperone-lamp:latest

ADD . /setup/

#Used to specify the default chaplocal image
ENV _PARENT_IMAGE="chapdev/chaperone-named-manager:latest"

RUN /setup/build/install.sh

PORT 8080 8443 8053/udp 8053/tcp
