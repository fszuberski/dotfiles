#!/bin/sh

usage=N/A
temperature=N/A

for device in /sys/class/drm/card[0-9]*/device; do
    [ -r "$device/vendor" ] || continue
    [ "$(cat "$device/vendor")" = '0x1002' ] || continue
    [ "$(basename "$(readlink "$device/driver")")" = 'amdgpu' ] || continue

    if [ -r "$device/gpu_busy_percent" ]; then
        value=$(cat "$device/gpu_busy_percent")
        case $value in ''|*[!0-9]*) ;; *) usage="${value}%" ;; esac
    fi

    for label in "$device"/hwmon/hwmon*/temp*_label; do
        [ -r "$label" ] || continue
        [ "$(cat "$label")" = 'edge' ] || continue
        input=${label%_label}_input
        [ -r "$input" ] || continue
        value=$(cat "$input")
        case $value in ''|*[!0-9]*) continue ;; esac
        temperature="$((value / 1000))°C"
        break
    done
    break
done

printf 'GPU %4s %5s\n' "$usage" "$temperature"
