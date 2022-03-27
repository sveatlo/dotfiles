#!/bin/bash

ICON_BRIGHTNESS_FULL=""
ICON_BRIGHTNESS_HALF=""
ICON_BRIGHTNESS_EMPTY="<span font='FontAwesomeLight'></span>"
DDC_BRIGHTNESS_SCRIPT=$HOME/src/scripts/ddc_brightness.sh

tooltip=""

raw_out="$($DDC_BRIGHTNESS_SCRIPT -b "$1")"
monitor_bus=$(echo $raw_out | cut -d':' -f 1)
percent=$(echo $raw_out | cut -d':' -f 2)
monitor_model=$(ddcutil -b "$monitor_bus" capabilities | grep 'Model' | cut -d' ' -f2)
if [[ $? != 0 ]]; then
    exit 1
fi
percent=${percent%\\n}


ICON_BRIGHTNESS=""
if [[ $percent -ge 75 ]]; then
    ICON_BRIGHTNESS=$ICON_BRIGHTNESS_FULL
elif [[ $percent -ge 25 ]]; then
    ICON_BRIGHTNESS=$ICON_BRIGHTNESS_HALF
else
    ICON_BRIGHTNESS=$ICON_BRIGHTNESS_EMPTY
fi


echo "{\"text\": \"$ICON_BRIGHTNESS $percent%\", \"tooltip\": \"DDC monitor ($monitor_model): $percent%\"}"
