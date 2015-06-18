#!/bin/bash
set -e

#True of the length if "STRING" is zero.
if [ -z "$MYSQL_DB_HOST" ]; then
	MYSQL_DB_HOST='mysql'
fi

#setting default values
: ${MYSQL_DB_USER:=root}
: ${MYSQL_DB_PASSWORD:=$MYSQL_ENV_MYSQL_ROOT_PASSWORD}

TERM=dumb php -- "$MYSQL_DB_HOST" "$MYSQL_DB_USER" "$MYSQL_DB_PASSWORD" "$MYSQL_DB_NAME" <<'EOPHP'
<?php
// database might not exist, so let's try creating it (just to be safe)

$stderr = fopen('php://stderr', 'w');

list($host, $port) = explode(':', $argv[1], 2);

$maxTries = 10;
do {
	$mysql = new mysqli($host, $argv[2], $argv[3], '', (int)$port);
	if ($mysql->connect_error) {
		fwrite($stderr, "\n" . 'MySQL Connection Error: (' . $mysql->connect_errno . ') ' . $mysql->connect_error . "\n");
		--$maxTries;
		if ($maxTries <= 0) {
			exit(1);
		}
		sleep(3);
	}
} while ($mysql->connect_error);

//create pma database
if (!$mysql->query('CREATE DATABASE IF NOT EXISTS `phpmyadmin`')) {
    fwrite($stderr, "\n" . 'MySQL "CREATE DATABASE" Error: ' . $mysql->error . "\n");
    $mysql->close();
    exit(1);
}

//add privileges to pma user
if (!$mysql->query("GRANT SELECT, INSERT, UPDATE, DELETE ON phpmyadmin.* TO 'pma'@'%'  IDENTIFIED BY 'pmapass'")) {
    fwrite($stderr, "\n" . 'MySQL "GRANT PRIVILEGES" Error: ' . $mysql->error . "\n");
    $mysql->close();
    exit(1);
}


//Execute a mysql file: http://php.net/manual/en/mysqli.multi-query.php
$commands = file_get_contents("/usr/src/phpmyadmin/sql/create_tables.sql");

if (!$mysql->multi_query($commands)) {
    fwrite($stderr, "\n" . 'MySQL "Create Tables" Error: ' . $mysql->error . "\n");
    $mysql->close();
    exit(1);
}

$mysql->close();
EOPHP

if ! [ -e /var/www/html/phpmyadmin ]; then
    echo >&2 "phpMyAdmin not found in $(pwd) - copying now..."
    cp -ra /usr/src/phpmyadmin /var/www/html/
    echo >&2 "Complete! phpMyAdmin has been successfully copied to $(pwd)"
fi

#Execute docker CMD
exec "$@"
