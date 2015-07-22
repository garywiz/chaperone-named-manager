#!/bin/bash

distdir=/var/lib/mysql
appdbdir=$VAR_DIR/mysql

function dolog() { logger -t mysql.sh -p info $*; }

if [ $CONTAINER_INIT == 1 ]; then
    dolog "hiding distribution mysql files in /etc so no clients see them"
    sudo bash -c "cd /etc; mv my.cnf my.cnf-dist; mv mysql mysql-dist; mv $distdir $distdir-dist" >&/dev/null
fi

if [ $APPS_INIT == 1 ]; then
    if [ ! -d $appdbdir ]; then
	dolog "copying distribution $distdir to $appdbdir"
	sudo bash -c "cp -a $distdir-dist $appdbdir; chown -R ${USER:-mysql} $appdbdir"
    else
	dolong "existing $appdbdir found when initializing $APPS_DIR for the first time, not changed."
    fi
fi
