#!/usr/bin/env bash

if [[ "$1" == "disable" ]]; then
	# TODO: find a better way to disable simultaneous audio - this currently unloads all null sinks
	pactl unload-module module-null-sink
fi

if [[ "$#" -lt 2 ]]; then
	echo "You must specify at least 2 bluetooth mac addresses as arguments" >&2
	exit 1
fi

all_connected=$(bluetooth_connected_devices.sh)

# check that all mac_addresss are connected
for mac_address in "$@"; do
	grep "$mac_address" <<<"$all_connected" >/dev/null || {
		echo "mac_address $mac_address is not connected" >&2
		exit 1
	}
done

pactl load-module module-null-sink media.class=Audio/Sink sink_name=Simultaneous channel_map=stereo

# link all mac_addresss to the null sink
for mac_address in "$@"; do
	underlined_address=$(sed "s|:|_|g" <<<"$mac_address")

	pw-link "Simultaneous:monitor_FL" "bluez_output.$underlined_address.1:playback_FL"
	pw-link "Simultaneous:monitor_FL" "bluez_output.$underlined_address.1:playback_FR"
done
