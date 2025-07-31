#!/usr/bin/env zsh

# Get memory info in MB
MEMORY_INFO=$(vm_stat)

# Extract page size (usually 4096 bytes)
PAGE_SIZE=$(vm_stat | grep "page size" | awk '{print $8}')
if [ -z "$PAGE_SIZE" ]; then
    PAGE_SIZE=4096
fi

# Get memory stats (in pages)
PAGES_FREE=$(echo "$MEMORY_INFO" | grep "Pages free" | awk '{print $3}' | sed 's/\.//')
PAGES_ACTIVE=$(echo "$MEMORY_INFO" | grep "Pages active" | awk '{print $3}' | sed 's/\.//')
PAGES_INACTIVE=$(echo "$MEMORY_INFO" | grep "Pages inactive" | awk '{print $3}' | sed 's/\.//')
PAGES_SPECULATIVE=$(echo "$MEMORY_INFO" | grep "Pages speculative" | awk '{print $3}' | sed 's/\.//')
PAGES_WIRED=$(echo "$MEMORY_INFO" | grep "Pages wired down" | awk '{print $4}' | sed 's/\.//')

# Calculate memory in MB
MEMORY_FREE=$(( (PAGES_FREE + PAGES_SPECULATIVE) * PAGE_SIZE / 1024 / 1024 ))
MEMORY_USED=$(( (PAGES_ACTIVE + PAGES_INACTIVE + PAGES_WIRED) * PAGE_SIZE / 1024 / 1024 ))
MEMORY_TOTAL=$(( MEMORY_FREE + MEMORY_USED ))

# Calculate usage percentage
RAM_USAGE=$(( MEMORY_USED * 100 / MEMORY_TOTAL ))

# Set icon and color based on usage
if [ "$RAM_USAGE" -lt 50 ]; then
    RAM_ICON="󰍛"  # Low usage
    RAM_COLOR="0xffa6da95"  # Green
elif [ "$RAM_USAGE" -lt 80 ]; then
    RAM_ICON="󰍛"  # Medium usage
    RAM_COLOR="0xfff5a97f"  # Orange
else
    RAM_ICON="󰍛"  # High usage
    RAM_COLOR="0xffed8796"  # Red
fi

# Format memory display (show in GB if > 1GB)
if [ "$MEMORY_USED" -gt 1024 ]; then
    MEMORY_DISPLAY="$(( MEMORY_USED / 1024 )).$(( (MEMORY_USED % 1024) / 100 ))G"
else
    MEMORY_DISPLAY="${MEMORY_USED}M"
fi

# Update the bottom bar
bottom_bar --set ram \
    icon="$RAM_ICON" \
    icon.color="$RAM_COLOR" \
    label="$MEMORY_DISPLAY"
