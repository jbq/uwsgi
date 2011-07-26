#!/bin/bash
### BEGIN INIT INFO
# Provides:          uwsgi
# Required-Start:    $local_fs $remote_fs $network
# Required-Stop:     $local_fs $remote_fs $network
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start/stop uWSGI server instance(s)
### END INIT INFO

# Author: Leonid Borisenko <leo.borisenko@gmail.com>

# PATH should only include /usr/* if it runs after the mountnfs.sh script
PATH=/sbin:/usr/sbin:/bin:/usr/bin
DESC="app server(s)"
NAME="uwsgi"
DAEMON="/usr/bin/uwsgi"
SCRIPTNAME="/etc/init.d/${NAME}"

UWSGI_CONFDIR="/etc/uwsgi/apps-enabled"
UWSGI_RUNDIR="/run/uwsgi"

# Exit if the package is not installed
[ -x "$DAEMON" ] || exit 0

# Load the VERBOSE setting and other rcS variables
. /lib/init/vars.sh

# Read configuration variable file if it is present
[ -r "/etc/default/${NAME}" ] && . "/etc/default/${NAME}"

# Define LSB log_* functions.
# Depend on lsb-base (>= 3.0-6) to ensure that this file is present.
. /lib/lsb/init-functions

# Define supplementary functions
. /usr/share/uwsgi/init/snippets
. /usr/share/uwsgi/init/do_command

WHAT=$1
shift
case "$WHAT" in
  start)
    [ "$VERBOSE" != no ] && log_daemon_msg "Starting $DESC" "$NAME"
    do_command "$WHAT" "$@"
    RETVAL="$?"
    [ "$VERBOSE" != no ] && log_end_msg "$RETVAL"
  ;;

  stop)
    [ "$VERBOSE" != no ] && log_daemon_msg "Stopping $DESC" "$NAME"
    do_command "$WHAT" "$@"
    RETVAL="$?"
    [ "$VERBOSE" != no ] && log_end_msg "$RETVAL"
  ;;

  status)
    if [ -z "$1" ]; then
      [ "$VERBOSE" != no ] && log_failure_msg "which one?"
    else
      status_of_proc -p "$(find_specific_pidfile "$1")" "$DAEMON" "$NAME" \
        && exit 0 \
        || exit $?
    fi
  ;;

  reload)
    [ "$VERBOSE" != no ] && log_daemon_msg "Reloading $DESC" "$NAME"
    do_command "$WHAT" "$@"
    RETVAL="$?"
    [ "$VERBOSE" != no ] && log_end_msg "$RETVAL"
  ;;

  force-reload)
    [ "$VERBOSE" != no ] && log_daemon_msg "Forced reloading $DESC" "$NAME"
    do_command "$WHAT" "$@"
    RETVAL="$?"
    [ "$VERBOSE" != no ] && log_end_msg "$RETVAL"
  ;;

  restart)
    [ "$VERBOSE" != no ] && log_daemon_msg "Restarting $DESC" "$NAME"
    CURRENT_VERBOSE=$VERBOSE
    VERBOSE=no
    do_command stop "$@"
    VERBOSE=$CURRENT_VERBOSE
    case "$?" in
      0)
        do_command start "$@"
        RETVAL="$?"
        [ "$VERBOSE" != no ] && log_end_msg "$RETVAL"
      ;;
      *)
        # Failed to stop
        [ "$VERBOSE" != no ] && log_end_msg 1
      ;;
    esac
  ;;

  *)
    echo "Usage: $SCRIPTNAME {start|stop|status|restart|reload|force-reload}" >&2
    exit 3
  ;;
esac

:
