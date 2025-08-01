#!/usr/bin/env zsh

if [[ "$SENDER" == "mouse.clicked" ]]; then
    # Get the slider percentage and set system volume
    PERCENTAGE=$(sketchybar --query volume_slider | jq -r '.slider.percentage')
    osascript -e "set volume output volume $PERCENTAGE"
    
    # Ensure it's unmuted when adjusting volume
    osascript -e "set volume output muted false"
    
    # Update the volume display
    $PLUGIN_SHARED_DIR/volume.sh
    
elif [[ "$SENDER" == "mouse.entered" ]]; then
    # Mouse entered slider - keep popup visible
    touch /tmp/sketchybar_slider_hover
    sketchybar --set volume popup.drawing=true
    
elif [[ "$SENDER" == "mouse.exited" ]]; then
    # Mouse left slider - hide popup if not on volume icon
    rm -f /tmp/sketchybar_slider_hover
    (sleep 0.1 && {
        if [[ ! -f /tmp/sketchybar_volume_state ]]; then
            sketchybar --set volume popup.drawing=false
        fi
    }) &
fi
