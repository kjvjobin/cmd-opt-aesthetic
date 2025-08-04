#!/usr/bin/env zsh

# Check WiFi status
WIFI_STATUS=$(networksetup -getairportpower en0 | awk '{print $4}')

if [[ "$WIFI_STATUS" == "On" ]]; then
# Get SSID using the system_profiler method that worked in your debug
SSID=$(system_profiler SPAirPortDataType | grep -A1 "Current Network Information:" | grep -v "Current Network Information" | grep ":" | head -1 | sed 's/^[[:space:]]*//' | sed 's/:.*$//')

if [[ -n "$SSID" ]]; then
# Connected
ICON="󰤨"
COLOR="0xffa6da95" # Green
LABEL="$SSID"
else
# Not connected
ICON="󰤮"
COLOR="0xfff5a97f" # Orange
LABEL="No WiFi"
fi
else
# WiFi off
ICON="󰤭"
COLOR="0xff6e738d" # Gray
LABEL="Off"
fi

# Update the WiFi item
sketchybar --set wifi icon="$ICON" icon.color="$COLOR" label="$LABEL" label.drawing=true
