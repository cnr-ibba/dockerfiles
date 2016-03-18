#!/bin/bash
set -e

#True of the length if "STRING" is zero.
if [ -z "$POSTGRES_HOST" ]; then
	POSTGRES_DB_HOST='postgres'
fi

#setting default values
: ${POSTGRES_USER:=root}
: ${POSTGRES_PASSWORD:=$MYSQL_ENV_POSTGRES_PASSWORD}

if ! [ -e /var/www/html/phppgadmin ]; then
    echo >&2 "phppgadmin not found in $(pwd) - copying now..."
    cp -ra /usr/src/phppgadmin /var/www/html/
    echo >&2 "Complete! phppgadmin has been successfully copied to $(pwd)"
fi

#Execute docker CMD
exec "$@"
