#!/bin/bash
# Usage: ./restore_layout.sh [NUMBER] [NAME]
# eg. ./restore_layout.sh 1 "1 primary"

LAYOUTS_DIR=$HOME/.config/sway/layouts

case "$1" in
*)
	~/src/scripts/sway-layout-restore.py --ws "$2" "$LAYOUTS_DIR/workspace-$1.json"
	;;
esac

sleep 0.5
