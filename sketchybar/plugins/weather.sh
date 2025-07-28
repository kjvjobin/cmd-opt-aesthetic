#!/usr/bin/env zsh

IP=$(curl -s https://ipinfo.io/ip)
LOCATION_JSON=$(curl -s https://ipinfo.io/$IP/json)

LOCATION="$(echo $LOCATION_JSON | jq -r '.city')"
REGION="$(echo $LOCATION_JSON | jq -r '.region')"

LOCATION_ESCAPED="${LOCATION// /+}+${REGION// /+}"
WEATHER_JSON=$(curl --http1.0 -A "Mozilla/5.0" "https://wttr.in/$LOCATION_ESCAPED?format=j1")

if [ -z "$WEATHER_JSON" ]; then
    sketchybar --set $NAME label="$LOCATION"
    sketchybar --set $NAME icon="" icon.color=0xffffffff
    exit
fi

WEATHER_DESCRIPTION=$(echo $WEATHER_JSON | jq -r '.current_condition[0].weatherDesc[0].value')

# Icon for weather condition
case "$WEATHER_DESCRIPTION" in
    *[Ss]unny* | *[Cc]lear*)
        WEATHER_ICON=""; WEATHER_COLOR=0xffffd700 ;;
    *[Pp]artly*[Cc]loudy*)
        WEATHER_ICON=""; WEATHER_COLOR=0xffc0c0c0 ;;
    *[Cc]loudy* | *[Oo]vercast*)
        WEATHER_ICON=""; WEATHER_COLOR=0xffa9a9a9 ;;
    *[Rr]ain* | *[Dd]rizzle*)
        WEATHER_ICON=""; WEATHER_COLOR=0xff87ceeb ;;
    *[Tt]hunder*)
        WEATHER_ICON=""; WEATHER_COLOR=0xffffa500 ;;
    *[Ss]now*)
        WEATHER_ICON="❄"; WEATHER_COLOR=0xffadd8e6 ;;
    *[Ff]og* | *[Mm]ist*)
        WEATHER_ICON="🌫"; WEATHER_COLOR=0xffcccccc ;;
    *)
        WEATHER_ICON=""; WEATHER_COLOR=0xffffffff ;;
esac

# Set the weather icon with its color and update label
sketchybar --set $NAME \
    icon="$WEATHER_ICON" \
    icon.color="$WEATHER_COLOR" \
    label="$WEATHER_DESCRIPTION"
