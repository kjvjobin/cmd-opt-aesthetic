#!/usr/bin/env zsh

# Get current volume level
VOLUME=$(osascript -e "output volume of (get volume settings)")

case $VOLUME in
0)
    ICON="󰸈"  # Volume muted (0%)
    ;;
[1-9]|[12][0-9]|30)
    ICON="󰕿"  # Volume low - 0 waves (1-30%)
    ;;
[4-6][0-9]|70)
    ICON="󰖀"  # Volume medium - 1 wave (40-70%)
    ;;
[8-9][0-9]|100)
    ICON="󰕾"  # Volume high - full/3 waves (80-100%)
    ;;
*)
    ICON="󰖀"  # Default to medium volume icon
    ;;
esac

sketchybar --set volume icon="$ICON"