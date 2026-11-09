#!/bin/sh

connections=$(nmcli -t -f TYPE connection show --active 2>/dev/null) || {
    printf '{"text":"󰌾","class":"unknown","tooltip":"NetworkManager unavailable"}\n'
    exit 0
}

if printf '%s\n' "$connections" | grep -Eq '^(vpn|wireguard)$'; then
    printf '{"text":"󰌾","class":"active","tooltip":"VPN active"}\n'
else
    printf '{"text":"󰌾","class":"inactive","tooltip":"No active NetworkManager VPN"}\n'
fi
