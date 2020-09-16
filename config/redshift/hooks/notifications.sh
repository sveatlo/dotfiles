#!/bin/sh
case $1 in
    period-changed)
        exec notify-send -a "System" "Redshift" "Period changed to $3"
        ;;
esac

