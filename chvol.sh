#!/bin/sh
# usage: chvol.sh <pamixer args>, e.g. -i 10, -d 1, -t
pamixer --allow-boost --set-limit 150 "$@"
volume=$(pamixer --get-volume)
output="Volume: $volume%"
[ "$(pamixer --get-mute)" = true ] && output="$output (muted)"
dunstify -a "changeVolume" -u low -i audio-volume-high -h string:x-dunst-stack-tag:volume -h int:value:"$volume" "$output"
