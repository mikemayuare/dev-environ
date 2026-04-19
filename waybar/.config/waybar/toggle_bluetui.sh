#!/bin/bash

# Check if impala window exists
if hyprctl clients | grep -q "bluetui"; then
  # Close it
  hyprctl dispatch closewindow "title:bluetui"
else
  # Open it
  ghostty --title=bluetui -e sh -c bluetui
fi
