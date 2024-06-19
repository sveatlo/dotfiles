#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/SCRIPTS_ENV"

LOC=$($SCRIPTS_DIR/geolocateme.py)
LAT=$(echo $LOC | cut -d';' -f1)
LON=$(echo $LOC | cut -d';' -f2)

killall -q wlsunset

wlsunset -t 3000 -l $LAT -L $LON
