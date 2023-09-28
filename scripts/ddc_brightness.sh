#!/usr/bin/env bash

set -e
shopt -s extglob;

monitor_bus=""
monitor_capabilities=""

maxbars=24
step=5
notificationduration=500
notificationcategory="System"
notificationtitle="Brightness"


get_brightness_status() {
    ddcutil --bus $monitor_bus getvcp -t 10 | grep 'VCP'
}

current_brightness() {
    raw_out=$1
    current_brightness=$(echo "$raw_out" | grep 'VCP' | cut -d' ' -f4)
    echo "$current_brightness"
}

max_brightness() {
    raw_out=$1
    current_brightness=$(echo "$raw_out" | grep 'VCP' | cut -d' ' -f4)
    max_brightness=$(echo "$raw_out" | grep 'VCP' | cut -d' ' -f5)
    echo "$max_brightness"
}

set_brightness() {
    new_value=$1
    max=$2

    ddcutil --bus $monitor_bus setvcp 10 $new_value
    pkill -SIGRTMIN+7 waybar
    display_notification "$new_value" "$max"
}

increase_brightness() {
    status=$(get_brightness_status)
    cur=$(current_brightness "$status")
    max=$(max_brightness "$status")
    args="$cur $max $step"
    new_value=$(awk '{print int( ((($1/$2) * 100) + $3) / 100*$2 )}' <<< "$args")

    set_brightness "$new_value" "$max"
}

decrease_brightness() {
    status=$(get_brightness_status)
    cur=$(current_brightness "$status")
    max=$(max_brightness "$status")
    args="$cur $max $step"
    new_value=$(awk '{print int( ((($1/$2) * 100) - $3) / 100*$2 )}' <<< "$args")

    set_brightness "$new_value" "$max"
}

# Show notification
display_notification() {
    cur=$1
    max=$2
    percent=$(echo "$cur $max" | awk '{print int(($1/$2) * 100)}')

    notify-send \
        -h int:value:${percent} \
        -h string:x-canonical-private-synchronous:anything \
        -t $notificationduration \
        -a "$notificationcategory" \
        "$notificationtitle" \
        "$(printf '%3d' $percent)%"

}

# parse options
OPTIND=1
while getopts "b:" opt; do
    case "$opt" in
        b)  monitor_bus=$OPTARG
        ;;
    esac
done
shift $((OPTIND-1))
[ "${1:-}" = "--" ] && shift

if [[ -z "$monitor_bus" ]]; then
    # autodetect (??)
    monitor_bus=$(ddcutil detect | grep -B10 'VCP version' | grep -oE 'I2C bus:.*' | awk 'match($0, "I2C bus:  /dev/i2c-([0-9]+)", m){print m[1]}' | head -1)
fi

# # TODO: use -t and parse?
# monitor_capabilities=$(ddcutil --bus "$monitor_bus" capabilities 2>&1)
# if [[ $? -gt 0 ]]; then
#     echo "cannot query monitor (bus $monitor_bus) capabilities: $monitor_capabilities" >&2
#     exit 1
# fi
#
# echo $monitor_capabilities | grep -o 'Feature.*Brightness' >/dev/null 2>&1
# if [[ $? -gt 0 ]]; then
#     echo "monitor (bus $monitor_bus) doesn't support brightness control" >&2
#     exit 1
# fi

case $1 in
    up)
        increase_brightness
        ;;
    down)
        decrease_brightness
        ;;
    [0-9][0-9][0-9] | [0-9][0-9] | [0-9])
        status=$(get_brightness_status)
        max=$(max_brightness "$status")
        set_brightness "$1" "$max"
        ;;
    *)
        status=$(get_brightness_status)
        cur=$(current_brightness "$status")
        max=$(max_brightness "$status")
        percent=$(echo "$cur $max" | awk '{print int(($1/$2) * 100)}')
        echo "$monitor_bus:$percent"
        ;;
esac
