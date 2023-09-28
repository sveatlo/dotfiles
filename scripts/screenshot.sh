#!/bin/bash


area=$(swaymsg -t get_tree | jq -r '.. | select(.pid? and .visible?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | slurp)
if [[ $? -ne 0 ]]; then
    notify-send -a "System" "Screenshot" "Area selection failed"
    exit 1
fi

grim -g "$area" - | wl-copy

if [[ $? -ne 0 ]]; then
    notify-send -a "System" "Screenshot" "Screenshot failed"
else
    notify-send -a "System" "Screenshot" "Screenshot copied to clipboard"
fi
