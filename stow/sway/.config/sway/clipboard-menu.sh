#!/bin/sh
set -eu

selection=$(cliphist list | rofi -dmenu -p Clipboard) || exit 0
[ -n "$selection" ] || exit 0
printf '%s\n' "$selection" | cliphist decode | wl-copy
