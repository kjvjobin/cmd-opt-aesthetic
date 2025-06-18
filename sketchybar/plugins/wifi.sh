#!/usr/bin/env zsh

# Get current SSID
CURRENT_NETWORK=$(system_profiler SPAirPortDataType 2>/dev/null | \
  grep -A 1 "Current Network Information:" | \
  awk 'NR==2 { gsub(/^[ \t]+/, ""); gsub(/:$/, ""); print }')

if [[ -z "$CURRENT_NETWORK" || "$CURRENT_NETWORK" == "None" ]]; then
  # Not connected
  ICON="󰖪"  # Disconnected icon
  LABEL="No-Fi"
  COLOR="0xfff38ba8"  # Red
else
  # Connected
  ICON="󰖩"  # WiFi icon
  SHORT_NAME="${CURRENT_NETWORK:0:3}_${CURRENT_NETWORK: -2}"
  LABEL="$SHORT_NAME"
  COLOR="0xffa6da95"  # Green
fi

sketchybar --set wifi icon="$ICON" label="$LABEL" icon.color="$COLOR"
