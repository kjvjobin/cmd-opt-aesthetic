#!/usr/bin/env zsh

LOCKFILE="/tmp/sketchybar_volume_scroll.lock"

# Store scroll direction if we haven't already within debounce window
if [[ "$SENDER" == "mouse.scrolled" ]]; then
    if [[ ! -f "$LOCKFILE" ]]; then
        echo "$SCROLL_DELTA" > "$LOCKFILE"
        (sleep 0.2 && rm -f "$LOCKFILE") &
    else
        # A scroll is already in progress — skip
        exit 0
    fi
fi

# Get current volume and mute status
VOLUME=$(osascript -e "output volume of (get volume settings)")
MUTED=$(osascript -e "output muted of (get volume settings)")

# Scroll logic (read stored scroll direction)
if [[ "$SENDER" == "mouse.scrolled" ]]; then
    SCROLL_DELTA=$(cat "$LOCKFILE" 2>/dev/null)

    if [[ "$SCROLL_DELTA" -gt 0 ]]; then
        # Scroll up = decrease
        NEW_VOLUME=$((VOLUME - 10))
        [[ $NEW_VOLUME -gt 100 ]] && NEW_VOLUME=100
    elif [[ "$SCROLL_DELTA" -lt 0 ]]; then
        # Scroll down = increase
        NEW_VOLUME=$((VOLUME + 10))
        [[ $NEW_VOLUME -lt 0 ]] && NEW_VOLUME=0
    else
        NEW_VOLUME=$VOLUME
    fi

    osascript -e "set volume output volume $NEW_VOLUME"
    osascript -e "set volume output muted false"
    VOLUME=$NEW_VOLUME
    MUTED="false"
fi

# Icon selection
case $VOLUME in
0)
    ICON="󰸈"
    ;;
[1-9]|[12][0-9]|30)
    ICON="󰕿"
    ;;
[4-6][0-9]|70)
    ICON="󰖀"
    ;;
[8-9][0-9]|100)
    ICON="󰕾"
    ;;
*)
    ICON="󰖀"
    ;;
esac

# Color based on volume level
if [[ "$MUTED" == "true" ]] || [[ "$VOLUME" == "0" ]]; then
    COLOR="0xff6e738d"
    ICON="󰸈"
elif [[ "$VOLUME" -le 30 ]]; then
    COLOR="0xfff5a97f"
elif [[ "$VOLUME" -le 70 ]]; then
    COLOR="0xffa6da95"
else
    COLOR="0xfffc030f"
fi

# Update UI
sketchybar --set volume icon="$ICON" icon.color="$COLOR"
sketchybar --set volume_slider slider.percentage="$VOLUME" slider.highlight_color="$COLOR"

# Popup behavior
if [[ "$SENDER" == "mouse.entered" ]]; then
    sketchybar --set volume popup.drawing=true
    echo "volume_hover" > /tmp/sketchybar_volume_state
elif [[ "$SENDER" == "mouse.exited" ]]; then
    (sleep 0.1 && {
        if [[ ! -f /tmp/sketchybar_slider_hover ]]; then
            sketchybar --set volume popup.drawing=false
            rm -f /tmp/sketchybar_volume_state
        fi
    }) &
fi
