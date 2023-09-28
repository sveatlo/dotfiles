#!/bin/sh

~/src/scripts/restore_layout.sh 20 "20 mon"
~/src/scripts/restore_layout.sh 5 "5 IM"; sleep 5
~/src/scripts/restore_layout.sh 2 "2 term"
~/src/scripts/restore_layout.sh 1 "1 www"

if [[ ! -f /tmp/mopidy-initialized ]]; then
    touch /tmp/mopidy-initialized
    systemctl --user restart mopidy.service
fi

~/src/scripts/run-waybar.sh >/dev/null 2>&1 &!
systemctl --user restart bridge redshift-gtk.service
