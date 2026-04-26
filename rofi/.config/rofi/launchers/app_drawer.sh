#!/usr/bin/env bash
# =============================================================================
#  apps.sh — Nord-themed Rofi App Launcher
#  Uses rofi drun mode — reads .desktop files automatically
#  Theme: ~/.config/rofi/launchers/themes/nord.rasi
# =============================================================================

THEME=$(cat "$HOME/.config/rofi/theme")

rofi \
  -display-drun "  Apps" \
  -show drun \
  -drun-display-format "{name}" \
  -hover-select \
  -me-select-entry '' \
  -me-accept-entry 'MousePrimary' \
  -show-icons \
  -columns 1 \
  -theme "$THEME" \
  -theme-str "listview { lines: 12; }"
