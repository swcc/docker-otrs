#!/usr/bin/env bash
SPAWN_FCGI="/usr/bin/spawn-fcgi"
DAEMON="/usr/sbin/fcgiwrap"
DAEMON_OPTS="-f"
NAME="fcgiwrap"
DESC="FastCGI wrapper"
PIDFILE="/var/run/$NAME.pid"

# FCGI_APP Variables
FCGI_CHILDREN="1"
FCGI_SOCKET="/var/run/$NAME.socket"
FCGI_USER="www-data"
FCGI_GROUP="www-data"
# Socket owner/group (will default to FCGI_USER/FCGI_GROUP if not defined)
FCGI_SOCKET_OWNER="www-data"
FCGI_SOCKET_GROUP="www-data"

ARGS="-P $PIDFILE -F $FCGI_CHILDREN -s $FCGI_SOCKET -a $FCGI_ADDR -p $FCGI_PORT -u $FCGI_USER -U $FCGI_SOCKET_OWNER -g $FCGI_GROUP -G $FCGI_SOCKET_GROUP -n"
env -i $ENV_VARS $SPAWN_FCGI $ARGS -- $DAEMON $DAEMON_OPTS
