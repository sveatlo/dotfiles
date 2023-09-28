#!/bin/bash

action=$1
playerctl_active=$( [[ $(playerctl -l 2>&1) == "No players were found" ]] && echo 0 || echo 1)

toggleplay() {
    playerctl play-pause
}

pause() {
    playerctl pause
}

next() {
    playerctl next
}

prev() {
    playerctl previous
}

process() {
    case $action in
        toggleplay | next | prev)
            $action
            ;;
        *)
            echo "Invalid action"
            exit 1
            ;;
    esac
}

process
