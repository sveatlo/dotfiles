#!/bin/bash

SCRIPT_PATH=$HOME/src/scripts/mpris-player.py
FORMAT='<span font="FontAwesome">{icon}</span> {:artist:{artist} - :}{:title:{title}:}{:-title:{filename}:}'

$SCRIPT_PATH -f "$FORMAT"
