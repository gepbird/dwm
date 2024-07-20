#!/usr/bin/env nix-shell
#!nix-shell -i bash -p xorg.xorgserver inotify-tools
exec Xephyr -resizeable :1 &
while true; do
  sleep 0.1
  DISPLAY=:1 nix run || inotifywait -q -e close_write . 
done
