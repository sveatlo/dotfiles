#!/usr/bin/env bash

case $BLOCK_BUTTON in
    4)
        ~/src/scripts/brightness.sh up
        ;;
    5)
        ~/src/scripts/brightness.sh down
        ;;
esac

echo "$(xbacklight -get | awk '{print int(($0/5)+0.5)*5}')%"
