#!/bin/sh

# Exit wit nonzero status if something goes wrong
trap 'exit' ERR

prog="mysqld"

# Set timeouts here so they can be overridden from /etc/sysconfig/mysqld
STARTTIMEOUT=120
STOPTIMEOUT=60

lockfile=/var/lock/subsys/$prog

# Run some action. Log its output.
action() {
  local STRING rc

  STRING=$1
  echo -n "$STRING "
  shift
  "$@" && success $"$STRING" || failure $"$STRING"
  rc=$?
  echo
  return $rc
}

# Log that something succeeded
success() {
  [ "$BOOTUP" != "verbose" -a -z "${LSB:-}" ] && echo_success
  return 0
}

# Log that something failed
failure() {
  local rc=$?
  [ "$BOOTUP" != "verbose" -a -z "${LSB:-}" ] && echo_failure
  [ -x /bin/plymouth ] && /bin/plymouth --details
  return $rc
}

echo_success() {
  [ "$BOOTUP" = "color" ] && $MOVE_TO_COL
  echo -n "["
  [ "$BOOTUP" = "color" ] && $SETCOLOR_SUCCESS
  echo -n $"  OK  "
  [ "$BOOTUP" = "color" ] && $SETCOLOR_NORMAL
  echo -n "]"
  echo -ne "\r"
  return 0
}

echo_failure() {
  [ "$BOOTUP" = "color" ] && $MOVE_TO_COL
  echo -n "["
  [ "$BOOTUP" = "color" ] && $SETCOLOR_FAILURE
  echo -n $"FAILED"
  [ "$BOOTUP" = "color" ] && $SETCOLOR_NORMAL
  echo -n "]"
  echo -ne "\r"
  return 1
}

# extract value of a MySQL option from config files
# Usage: get_mysql_option SECTION VARNAME DEFAULT
# result is returned in $result
# We use my_print_defaults which prints all options from multiple files,
# with the more specific ones later; hence take the last match.
get_mysql_option(){
	result=`/usr/bin/my_print_defaults "$1" | sed -n "s/^--$2=//p" | tail -n 1`
	if [ -z "$result" ]; then
	    # not found, use default
	    result="$3"
	fi
}

get_mysql_option mysqld datadir "/var/lib/mysql"
datadir="$result"
get_mysql_option mysqld socket "$datadir/mysql.sock"
socketfile="$result"
get_mysql_option mysqld_safe log-error "/var/log/mysqld.log"
errlogfile="$result"
get_mysql_option mysqld_safe pid-file "/var/run/mysqld/mysqld.pid"
mypidfile="$result"


if [ ! -d "$datadir/mysql" ] ; then
	    # First, make sure $datadir is there with correct permissions
	    if [ ! -e "$datadir" -a ! -h "$datadir" ]
	    then
				mkdir -p "$datadir" || exit 1
	    fi
	    chown mysql:mysql "$datadir"
	    chmod 0755 "$datadir"

	    # Now create the database
	    action $"Initializing MySQL database: " /usr/bin/mysql_install_db --datadir="$datadir" --user=mysql
	    ret=$?
	    chown -R mysql:mysql "$datadir"
	    if [ $ret -ne 0 ] ; then
				return $ret
	    fi
else
	chown mysql:mysql "$datadir"
	chmod 0755 "$datadir"
fi

exec "$@"

# Pass all the options determined above, to ensure consistent behavior.
# In many cases mysqld_safe would arrive at the same conclusions anyway
# but we need to be sure.  (An exception is that we don't force the
# log-error setting, since this script doesn't really depend on that,
# and some users might prefer to configure logging to syslog.)
# Note: set --basedir to prevent probes that might trigger SELinux
# alarms, per bug #547485
exec "$@  --datadir="$datadir" --socket="$socketfile" \
	--pid-file="$mypidfile" \
	--basedir=/usr --user=mysql 2>&1"
