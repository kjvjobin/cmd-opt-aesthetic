#!/usr/bin/env zsh

# Get CPU usage percentage
CPU_USAGE=$(top -l 1 | grep "CPU usage" | awk '{print $3}' | sed 's/%//')

# If we can't get CPU usage, try alternative method
if [ -z "$CPU_USAGE" ]; then
    CPU_USAGE=$(ps -A -o %cpu | awk '{s+=$1} END {printf "%.0f", s}')
fi

# Round to integer
CPU_USAGE=$(printf "%.0f" "$CPU_USAGE")

# Set icon and color based on usage
if [ "$CPU_USAGE" -lt 30 ]; then
    CPU_ICON="󰘚"  # Low usage
    CPU_COLOR="0xffa6da95"  # Green
elif [ "$CPU_USAGE" -lt 70 ]; then
    CPU_ICON="󰘚"  # Medium usage
    CPU_COLOR="0xfff5a97f"  # Orange
else
    CPU_ICON="󰘚"  # High usage
    CPU_COLOR="0xffed8796"  # Red
fi

# Update the bottom bar
bottom_bar --set cpu \
    icon="$CPU_ICON" \
    icon.color="$CPU_COLOR" \
    label="${CPU_USAGE}%"
