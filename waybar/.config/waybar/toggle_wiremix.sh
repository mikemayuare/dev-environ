#!/bin/bash

# Check if wiremix window exists
if hyprctl clients | grep -q "wiremix"; then
  # Close it
  hyprctl dispatch closewindow "title:wiremix"
else
  # Open it
  ghostty --title=wiremix -e sh -c wiremix
fi
