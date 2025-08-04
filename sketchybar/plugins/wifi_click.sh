#!/usr/bin/env zsh

# Check current WiFi status
WIFI_STATUS=$(networksetup -getairportpower en0 | awk '{print $4}')

if [[ "$WIFI_STATUS" == "On" ]]; then
    # Turn WiFi off
    networksetup -setairportpower en0 off
    sketchybar --set wifi icon="󰤭" icon.color="0xff6e738d" label="Off"
else
    # Turn WiFi on
    networksetup -setairportpower en0 on
    # Wait a moment for WiFi to initialize
    sleep 2
    # Update WiFi display
    $PLUGIN_SHARED_DIR/wifi.sh
fi
