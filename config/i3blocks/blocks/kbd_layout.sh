#!/usr/bin/env bash


case $BLOCK_BUTTON in
    1)
        xkb-switch -n
        ;;
esac

layout=$(xkb-switch)
case $layout in
    "en_US")
        layout=US
        ;;
    "sk(qwerty)"|"'sk(qwerty)'")
        layout=SK
        ;;
esac

echo $layout
