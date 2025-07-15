#!/bin/bash
# ~/.config/polybar/scripts/awesome-workspaces.sh

# Colors from Catppuccin Mocha
ACTIVE_COLOR="#89b4fa"      # blue
OCCUPIED_COLOR="#cdd6f4"    # text
EMPTY_COLOR="#6c7086"       # overlay0
URGENT_COLOR="#f38ba8"      # red
BACKGROUND="#1e1e2e"        # base

# Function to get workspace info from awesome
get_workspaces() {
    # Use awesome-client to get workspace information
    echo 'return require("awful").screen.focused().selected_tag.name' | awesome-client 2>/dev/null | sed 's/^[[:space:]]*string[[:space:]]*"//' | sed 's/"[[:space:]]*$//' > /tmp/current_tag
    
    # Get all tags
    echo 'local s = require("awful").screen.focused(); local result = ""; for i = 1, #s.tags do local t = s.tags[i]; if t.selected then result = result .. "%{F#89b4fa}%{B#313244} " .. t.name .. " %{B-}%{F-}" elseif #t:clients() > 0 then result = result .. "%{F#cdd6f4} " .. t.name .. " %{F-}" else result = result .. "%{F#6c7086} " .. t.name .. " %{F-}" end end return result' | awesome-client 2>/dev/null | sed 's/^[[:space:]]*string[[:space:]]*"//' | sed 's/"[[:space:]]*$//'
}

# Main loop
while true; do
    get_workspaces
    sleep 0.1
done
