#!/usr/bin/env bash
# =============================================================================
#  clipboard.sh — Rofi Clipboard Manager
#  Uses cliphist + wl-copy
# =============================================================================

THEME=$(cat "$HOME/.config/rofi/theme")

CHOICE=$(cliphist list | rofi \
  -dmenu \
  -i \
  -p "  Clipboard" \
  -theme "$THEME" \
  -theme-str "listview { lines: 8; }" \
  -no-custom \
  -format s)

[[ -z "$CHOICE" ]] && exit 0

echo "$CHOICE" | cliphist decode | wl-copy
