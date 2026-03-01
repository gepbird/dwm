#!/bin/sh
percentage=$(brightnessctl --machine-readable set "$@" | hck -d, -f4)
dunstify \
  -u low \
  -h string:x-dunst-stack-tag:backlight \
  -h int:value:"$percentage" \
  "Brightness: ${percentage}"
