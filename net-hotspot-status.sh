#!/usr/bin/env bash
set -euo pipefail

profile_name="Myles"
ap_interface="ap0"

profile_uuid="$(nmcli -g connection.uuid connection show "$profile_name" 2>/dev/null | head -n 1)" || exit 1
[[ -n "$profile_uuid" ]] || exit 1

mode="$(nmcli -g 802-11-wireless.mode connection show uuid "$profile_uuid" 2>/dev/null)" || exit 1
[[ "$mode" == "ap" ]] || exit 2

profile_interface="$(nmcli -g connection.interface-name connection show uuid "$profile_uuid" 2>/dev/null)" || exit 1
device_exists=0
if nmcli -g DEVICE device status 2>/dev/null | grep -Fxq "$ap_interface"; then
  device_exists=1
fi

active=0
if nmcli -g UUID connection show --active 2>/dev/null | grep -Fxq "$profile_uuid"; then
  active=1
fi

printf '%s\t%s\t%s\t%s\n' "$profile_uuid" "$profile_interface" "$device_exists" "$active"
