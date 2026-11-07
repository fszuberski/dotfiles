#!/usr/bin/env bash

killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

echo "---" | tee -a /tmp/polybar.log

polybar primary -c ~/.config/polybar/config >>/tmp/polybarl.log 2>&1 &

echo "Bar launched..."
