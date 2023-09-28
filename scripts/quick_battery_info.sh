#!/bin/sh

upower -i $(upower -e | grep bat) | grep -E '(percentage|time|capacity|energy-rate)'
