#!/bin/sh

choice=$(printf 'Suspend\nShutdown\n' | rofi -dmenu -i -no-custom -p 'Power') || exit 0

case $choice in
    Suspend) systemctl suspend ;;
    Shutdown) systemctl poweroff ;;
esac
