#!/usr/bin/env bash

sudo tlp bat
echo quiet | sudo tee /sys/firmware/acpi/platform_profile

hyprctl keyword animations:enabled false
hyprctl keyword decoration:dim_inactive false
hyprctl keyword decoration:shadow:enabled false
hyprctl keyword decoration:blur:enabled false
hyprctl keyword misc:vfr true
