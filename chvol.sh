#!/bin/sh
sink="@DEFAULT_AUDIO_SINK@"
msgTag="volume"
cmd=$1
shift
case $cmd in
set-volume) wpctl "$cmd" -l 1.5 "$sink" "$@" ;;
*) wpctl "$cmd" "$sink" "$@" ;;
esac
status=$(wpctl get-volume "$sink")
volume=$(echo "$status" | awk '{ printf "%.0f", $2 * 100 }')
output="Volume: $volume%"
case $status in *MUTED*) output="$output (muted)" ;; esac
dunstify -a "changeVolume" -u low -i audio-volume-high -h string:x-dunst-stack-tag:$msgTag -h int:value:"$volume" "$output"
