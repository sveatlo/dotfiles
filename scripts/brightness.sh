#!/usr/bin/env bash

maxbars=24
step=5
notificationduration=500
notificationcategory="System"
notificationtitle="Brightness"

# Show notification
display_notification() {
    percent=$(brightnessctl -m | awk -F',' '{print $4}' | grep -Eo '[0-9]+')

    notify-send \
        -h int:value:${percent} \
        -h string:x-canonical-private-synchronous:anything \
        -t $notificationduration \
        -a "$notificationcategory" \
        "$notificationtitle" \
        "$(printf '%3d' $percent)%"

}

percent=$(brightnessctl -m | awk -F',' '{print $4}' | grep -Eo '[0-9]+')
case $1 in
    up)
        if [[ "$percent" -le 0 ]]; then
            swaymsg "output * dpms off"
            swaymsg "output * dpms on"
        fi
        brightnessctl s ${step}%+
        display_notification
        ;;
    down)
        if [[ "$percent" -lt 1 ]]; then
            swaymsg "output * dpms off"
        fi
        brightnessctl s ${step}%-
        display_notification
        ;;
    *)
        brightnessctl s $1
        display_notification
        ;;
        # notify-send \
        # -h string:x-canonical-private-synchronous:anything \
        # -t $notificationduration \
        # -a "$notificationcategory" \
        # "$notificationtitle" \
        # "invalid command"
        # ;;
esac
