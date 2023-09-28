#!/bin/bash

bluetoothctl devices Connected | awk 'match($0, "(([0-9A-Z]{2}:?){6})", m){print m[1]}'
