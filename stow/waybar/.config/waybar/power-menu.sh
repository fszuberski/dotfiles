#!/bin/sh

choice=$(printf 'Suspend\nRestart\nShutdown\n' | rofi -dmenu -i -no-custom -p 'Power') || exit 0

case $choice in
    Suspend) systemctl suspend ;;
    Restart) systemctl reboot ;;
    Shutdown) systemctl poweroff ;;
esac
