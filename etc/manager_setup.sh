#!/bin/bash

sentinel=$APPS_DIR/var/run/manager.setup    # present if we've already initialized namedmanager
NDM=$APPS_DIR/www/namedmanager	            # the namedmanager install directory

# Always reprocess the config files so that config changes can be done at any time.

mkdir -p $VAR_DIR/bind
cd $APPS_DIR/etc/bind
envcp --overwrite --strip=.tpl *.tpl $VAR_DIR/bind

# This however is done only once for the data container

if [ -f $sentinel ]; then
  exit
fi

date > $sentinel

mkdir -p $VAR_DIR/named-zones

if [ ! -f "$VAR_DIR/named-zones/named.namedmanager.conf" ]; then
  echo "" >$VAR_DIR/named-zones/named.namedmanager.conf
fi

if [ "$CONFIG_MANAGER" == "true" ]; then
    echo SEEDING SQL DATABASE

    cd $APPS_DIR/www/namedmanager/sql
    mysql -u root --password=ChangeMe < `ls -1 *_install.sql | tail -1`

    # Load additional data
    envcp - <$APPS_DIR/etc/initial_data.sql.tpl | mysql -u root --password=ChangeMe namedmanager
fi
