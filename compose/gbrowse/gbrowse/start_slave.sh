#! /bin/bash

# https://docs.docker.com/engine/admin/multi-service_container/

# Start gbrowse_slave process
# --port     -p  <port>     Network port number to listen to (default 8101).
# --prefork  -f  <children> Number of preforked copies to run (default 1)
# --verbose  -v  <level>    Verbosity level (0-3)
# --user     -u  <name>     User to run under (same as current)
# --log      -l  <path>     Log file path (default, use STDERR)
# --pid          <path>     PID file path (default, none)
# --kill     -k             Kill running server (use in conjunction with --pid).
# --preload  <path>         Path to a config file containing override information
#                             and databases to preload
# --tmp|-T   <path>         Override location of configuration file cache files.
/usr/local/bin/gbrowse_slave --preload /etc/gbrowse2/slave_preload.conf \
  --user www-data --pid /var/run/gbrowse2.pid --port 8101 --verbose 3 \
  --prefork 1

status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start gbrowse_slave: $status"
  exit $status
fi

# Naive check runs checks once a minute to see if either of the processes exited.
# This illustrates part of the heavy lifting you need to do if you want to run
# more than one service in a container. The container will exit with an error
# if it detects that either of the processes has exited.
# Otherwise it will loop forever, waking up every 60 seconds

while /bin/true; do
  ps aux | grep gbrowse_slave | grep -q -v grep
  PROCESS_1_STATUS=$?

  # If the greps above find anything, they will exit with 0 status
  # If they are not both 0, then something is wrong
  if [ $PROCESS_1_STATUS -ne 0 ]; then
    echo "gbrowse_slave has already exited."
    exit -1
  fi
  sleep 60
done
