#!/usr/bin/env bash

set -e

DEFAULT_MODE=default
STATE_FILE_PATH=$HOME/.cache/idle-mode
LOCKER="swaylock"
LOCK_CMD="$LOCKER --daemonize"
# default timeouts
SCREEN_TIMEOUT=60
LOCK_TIMEOUT=90
SUSPEND_TIMEOUT=3600

MODE="$1"
if [[ "$MODE" == "" ]]; then
	if [[ -f "$STATE_FILE_PATH" ]]; then
		MODE=$(cat "$STATE_FILE_PATH" 2>/dev/null)
	fi
	MODE=${MODE:-$DEFAULT_MODE}
fi

echo "Switching locking mode to $MODE"
case "$MODE" in
home)
	SCREEN_TIMEOUT=30
	LOCK_TIMEOUT=3600
	SUSPEND_TIMEOUT=28800 # 8 hours
	;;
coworking)
	SCREEN_TIMEOUT=20
	LOCK_TIMEOUT=30
	SUSPEND_TIMEOUT=3600
	;;
$DEFAULT_MODE)
	# no timeout overrides for default
	;;
*)
	# no such mode
	echo "Mode '$MODE' doesn't exist" >&2

	# delete state file if it originates there
	if [[ "$1" == "" ]]; then # empty parameter means we loaded it from state file
		rm -f "$STATE_FILE_PATH"
	fi

	exit 1
	;;
esac

pkill swayidle || true

swayidle -w \
	timeout 30 "makoctl set-mode away" \
        resume "makoctl set-mode default" \
	timeout $SCREEN_TIMEOUT 'swaymsg "output * dpms off"' \
        resume 'swaymsg "output * dpms on"' \
	timeout $LOCK_TIMEOUT "$LOCK_CMD"\
	timeout $SUSPEND_TIMEOUT 'systemctl suspend' \
	before-sleep "$LOCK_CMD"\
	lock "$LOCK_CMD" \
	unlock "pkill $LOCKER" \
	idlehint $SCREEN_TIMEOUT &!

echo -n "$MODE" >$STATE_FILE_PATH

notify-send \
	-h string:x-canonical-private-synchronous:anything \
	-t 2000 \
	-a "System" \
	"System mode" \
	"Mode set $MODE"
