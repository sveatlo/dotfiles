#!/bin/bash

case $button in
    1)
        ~/src/scripts/player-mpris-tail.py previous
        ;;
    2)
        ~/src/scripts/player-mpris-tail.py play-pause
        ;;
    3)
        ~/src/scripts/player-mpris-tail.py next
        ;;
    *)
        ~/src/scripts/player-mpris-tail.py -f '♪ {:artist:t20:{artist}:}{:artist: - :}{:t40:{title}:} {icon-reversed}'
        ;;
esac
