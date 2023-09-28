#!/bin/sh

set -e

WALLPAPERS_DIR=$(xdg-user-dir PICTURES)/wallpapers
WALLPAPER=$(find "$WALLPAPERS_DIR" -type f | shuf -n 1 --random-source=/dev/urandom)
ln -s -f "$WALLPAPER" "$WALLPAPERS_DIR/current_wallpaper"

swaymsg -r -q output "*" bg "$WALLPAPERS_DIR/current_wallpaper" fill >/dev/null
