#!/bin/bash

TYPE=$1 # full, area, window,
shift

SUCCESS=69
if [[ "$TYPE" == "full" ]]; then
	hyprshot -z -m output --clipboard-only
	SUCCESS=$?
elif [[ "$TYPE" == "window" ]]; then
	hyprshot -z -m window --clipboard-only
	SUCCESS=$?
elif [[ "$TYPE" == "area" ]]; then
	hyprshot -z -m region --clipboard-only
	SUCCESS=$?
fi

if [[ $? -ne 0 ]]; then
	notify-send -a "System" "Screenshot" "Screenshot failed"
fi
