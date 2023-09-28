#!/usr/bin/env bash

maxbars=24
notificationduration=500
notificationcategory="System"
notificationtitle="Volume"

# The second parameter sets the step to change the volume by (and units to display)
# This may be in in % or dB (eg. 5% or 3dB)
STEP="${2:-5%}"

volume() {
	wpctl get-volume @DEFAULT_AUDIO_SINK@
}

# Show notification
display_notification() {
	percent=$(volume | cut -d' ' -f2)
	percent=$(bc <<<"$percent * 100 / 1")

	notify-send \
		-h int:value:${percent} \
		-h string:x-canonical-private-synchronous:anything \
		-t $notificationduration \
		-a "$notificationcategory" \
		"$notificationtitle" \
		"$(printf '%3d' $percent)%"
}

case $1 in
up)
	wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+

	display_notification
	;;
down)
	wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%-

	display_notification
	;;
mute)
	wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

	state="Mute"
	isoff=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -o 'MUTED')
	if [[ $? -ne 0 ]]; then
		state="Unmute"
	fi
	notify-send -t $notificationduration -a "$notificationtitle" "$state"
	;;
*)
	notify-send -a "Volume" "Error"
	;;
esac
