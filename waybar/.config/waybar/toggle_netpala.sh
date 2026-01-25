#!/bin/bash

# Check if impala window exists
if hyprctl clients | grep -q "title: netpala"; then
  # Close it
  hyprctl dispatch closewindow "title:netpala"
else
  # Open it
  uwsm app -- ghostty --title=netpala -e sh -c netpala
fi
