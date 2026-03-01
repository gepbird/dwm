#!/usr/bin/env nix-shell
#!nix-shell -i bash -p xorgserver inotify-tools
export DWM_TEST=1
exec Xephyr -resizeable -screen 1920x1080 :1 &
while true; do
  sleep 0.1
  DISPLAY=:1 nix run || inotifywait -q -e close_write . -r
done
