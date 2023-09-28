#!/bin/bash

kill -KILL $(pgrep swaylock)
ps aux | grep swaylock
# turn on displays
SWAYSOCK=$(ls /run/user/1000/sway-ipc.*.sock) swaymsg "output * dpms on"
