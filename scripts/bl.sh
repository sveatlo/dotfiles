#!/usr/bin/env bash

# set -ex

declare -A known_devices=(
	["headphones"]="94:DB:56:D8:FE:2B"
	["earphones"]="AC:80:0A:45:E4:C4"
	["speakers"]="40:EF:4C:C3:B9:EC"
	["jbl"]="D8:37:3B:DB:7C:91"
)

bluetoothctl power on

sleep 0.5

bluetoothctl agent on
bluetoothctl default-agent

if [[ $# == 0 ]]; then
	bluetoothctl disconnect
fi

for device in $*; do
	if [[ ! -z "${known_devices[$device]}" ]]; then
		device=${known_devices[$device]}
	fi

	bluetoothctl connect "$device"
	echo "connect $device"
done
