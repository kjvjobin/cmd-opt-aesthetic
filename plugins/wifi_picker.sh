#!/bin/bash

AIRPORT="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"

# Run airport and skip any line that starts with "WARNING" or "For "
SSID_LIST=$( "$AIRPORT" -s | awk '!/^WARNING/ && !/^For / && NR>1 {print $1}' | sort -u | grep -v '^$' )

if [[ -z "$SSID_LIST" ]]; then
  osascript -e 'display dialog "No Wi-Fi networks found." buttons {"OK"} default button "OK"'
  exit 1
fi

CHOICES=""
while IFS= read -r line; do
  CHOICES="$CHOICES\"$line\", "
done <<< "$SSID_LIST"
CHOICES="[${CHOICES%, }]"

CHOSEN_SSID=$(osascript -e "
  set ssidList to ${CHOICES}
  choose from list ssidList with prompt \"Choose a Wi-Fi network:\" without multiple selections allowed
")

if [[ "$CHOSEN_SSID" == "false" ]]; then
  exit 0
fi

SSID_PASSWORD=$(osascript -e 'display dialog "Enter password for Wi-Fi:" default answer "" with hidden answer' -e 'text returned of result')

networksetup -setairportnetwork en0 "$CHOSEN_SSID" "$SSID_PASSWORD"
