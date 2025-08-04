#!/usr/bin/env zsh

IP=$(curl -s https://ipinfo.io/ip)
LOCATION_JSON=$(curl -s https://ipinfo.io/$IP/json)

LOCATION="$(echo $LOCATION_JSON | jq -r '.city')"
REGION="$(echo $LOCATION_JSON | jq -r '.region')"

LOCATION_ESCAPED="${LOCATION// /+}+${REGION// /+}"
TEMP_JSON=$(curl -s --http1.0 -A "Mozilla/5.0" "https://wttr.in/$LOCATION_ESCAPED?format=j1")

TEMPERATURE=$(echo $TEMP_JSON | jq -r '.current_condition[0].temp_C')

# Color the thermometer based on temperature (check highest ranges first)
if [ "$TEMPERATURE" -ge 30 ]; then
    THERMO_COLOR=0xffff4500  # Red (30°C+)
elif [ "$TEMPERATURE" -ge 25 ]; then
    THERMO_COLOR=0xffffd700  # Yellow (25-29°C)
elif [ "$TEMPERATURE" -ge 21 ]; then
    THERMO_COLOR=0xff9fdb37  # Green (21-24°C)
else
    THERMO_COLOR=0xff87cefa  # Blue (≤20°C)
fi

# Set the thermometer icon with its color and update label
bottom_bar --set $NAME \
    icon="" \
    icon.color="$THERMO_COLOR" \
    label="$LOCATION $TEMPERATURE℃"
