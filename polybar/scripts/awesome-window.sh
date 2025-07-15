#!/bin/bash
# ~/.config/polybar/scripts/awesome-window.sh

# Function to get current window title
get_window_title() {
    echo 'if client.focus then return client.focus.name or "" else return "" end' | awesome-client 2>/dev/null | sed 's/^[[:space:]]*string[[:space:]]*"//' | sed 's/"[[:space:]]*$//'
}

# Main loop
while true; do
    title=$(get_window_title)
    if [ -n "$title" ]; then
        echo "$title"
    else
        echo "Desktop"
    fi
    sleep 0.1
done
