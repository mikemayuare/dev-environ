#!/bin/bash

killall swaync 2>/dev/null
pkill -SIGUSR2 waybar 2>/dev/null
