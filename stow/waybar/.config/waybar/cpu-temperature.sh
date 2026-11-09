#!/bin/sh

for sensor in /sys/class/hwmon/hwmon*; do
    [ -r "$sensor/name" ] || continue
    case $(cat "$sensor/name") in
        coretemp) wanted='Package id 0' ;;
        k10temp) wanted='Tctl' ;;
        *) continue ;;
    esac
    for label in "$sensor"/temp*_label; do
        [ -r "$label" ] || continue
        [ "$(cat "$label")" = "$wanted" ] || continue
        input=${label%_label}_input
        [ -r "$input" ] || continue
        value=$(cat "$input")
        case $value in ''|*[!0-9]*) continue ;; esac
        printf 'CPU %3d°C\n' "$((value / 1000))"
        exit 0
    done
done

printf 'CPU N/A\n'
