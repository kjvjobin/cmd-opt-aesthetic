#!/usr/bin/env zsh

IP=$(curl -s https://ipinfo.io/ip)
LOCATION_JSON=$(curl -s https://ipinfo.io/$IP/json)

LOCATION="$(echo $LOCATION_JSON | jq -r '.city')"
REGION="$(echo $LOCATION_JSON | jq -r '.region')"

LOCATION_ESCAPED="${LOCATION// /+}+${REGION// /+}"
WIND_JSON=$(curl -s --http1.0 -A "Mozilla/5.0" "https://wttr.in/$LOCATION_ESCAPED?format=j1")

WIND_DIRECTION=$(echo $WIND_JSON | jq -r '.current_condition[0].winddir16Point[-2:]')
WIND_SPEED=$(echo $WIND_JSON | jq -r '.current_condition[0].windspeedKmph')

# Direction based on WIND_DIRECTION
case "$WIND_DIRECTION" in
    "N")
        WIND_ICON="↑"  # North - wind blowing north (from south)
        ;;
    "NE")
        WIND_ICON="↗"  # Northeast
        ;;
    "E")
        WIND_ICON="→"  # East - wind blowing east (from west)
        ;;
    "SE")
        WIND_ICON="↘"  # Southeast
        ;;
    "S")
        WIND_ICON="↓"  # South - wind blowing south (from north)
        ;;
    "SW")
        WIND_ICON="↙"  # Southwest
        ;;
    "W")
        WIND_ICON="←"  # West - wind blowing west (from east)
        ;;
    "NW")
        WIND_ICON="↖"  # Northwest
        ;;
    *)
        WIND_ICON="?"   # Unknown direction
        ;;
esac

# Add wind speed if available
if [ -n "$WIND_SPEED" ]; then
    WIND_LABEL="$WIND_SPEED Kmph"
else
    WIND_LABEL=""
fi

# Update SketchyBar (use bottom_bar if this is for your bottom bar)
bottom_bar --set wind \
    icon="$WIND_ICON" \
    label="$WIND_LABEL"
