#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/SCRIPTS_ENV"

swaymsg -r -t SUBSCRIBE -m '["output"]' | while read -r output_change; do
	echo "Output change detected. Refreshing outputs..."
	OUTPUTS=$(swaymsg -r -t get_outputs)
	# ACTIVE_OUTPUTS=$(echo "$OUTPUTS" | jq -r -c 'map(select(.active) | .name)')
	ACTIVE_OUTPUTS=$(echo "$OUTPUTS" | jq -r -c 'map( .name )')
	COUNT=$(echo "$ACTIVE_OUTPUTS" | jq length)
	echo "Outputs detected: $(echo "$ACTIVE_OUTPUTS" | jq -r -c 'join(", ")')"

	case "$COUNT" in
	0) ;;
	1)
		$SCRIPTS_DIR/set-mode.sh standalone
		;;
	2)
		$SCRIPTS_DIR/set-mode.sh docked
		;;
	*)
		echo "Detected $COUNT active outputs. Switching to default mode."
		;;
	esac

	echo "----------"
	echo "Waiting for changes..."
done
