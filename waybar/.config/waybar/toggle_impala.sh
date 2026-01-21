#!/bin/bash

# Check if impala window exists
if hyprctl clients | grep -q "impala"; then
  # Close it
  hyprctl dispatch closewindow "title:impala"
else
  # Open it
  uwsm app -- ghostty --title=impala -e sh -c impala
fi
