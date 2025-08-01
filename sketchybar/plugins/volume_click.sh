#!/usr/bin/env zsh

# Toggle mute state
MUTED=$(osascript -e "output muted of (get volume settings)")

if [[ "$MUTED" == "true" ]]; then
    # Unmute
    osascript -e "set volume output muted false"
else
    # Mute
    osascript -e "set volume output muted true"
fi

# Update the volume display
$PLUGIN_SHARED_DIR/volume.sh
