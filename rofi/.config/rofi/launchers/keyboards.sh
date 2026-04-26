#!/usr/bin/env bash

# Keyboard layout switcher for Hyprland
# Switches between English US and English US International

CONF="$HOME/.config/hypr/input.conf"
THEME=$(cat "$HOME/.config/rofi/theme")

# Layout definitions: "Display Name|kb_layout|kb_variant"
LAYOUTS=(
  "English US|us|"
  "English US International|us|intl"
)
LINES=${#LAYOUTS[@]}
# Read current layout from config
current_layout=$(grep -oP '(?<=kb_layout = ).*' "$CONF" | tr -d ' ')
current_variant=$(grep -oP '(?<=kb_variant = ).*' "$CONF" | tr -d ' ')

# Build rofi menu entries, marking the active layout
menu_entries=""
for entry in "${LAYOUTS[@]}"; do
  name="${entry%%|*}"
  rest="${entry#*|}"
  layout="${rest%%|*}"
  variant="${rest##*|}"

  if [[ "$layout" == "$current_layout" && "$variant" == "$current_variant" ]]; then
    menu_entries+="  $name\n"
  else
    menu_entries+="$name\n"
  fi
done

# Show rofi menu
chosen=$(printf "%b" "$menu_entries" | rofi -dmenu \
  -p " Layout" \
  -theme "$THEME" \
  -hover-select \
  -me-select-entry '' \
  -me-accept-entry 'MousePrimary' \
  -theme-str "listview { lines: $LINES; }" \
  -i)

# Strip leading whitespace/marker if present
chosen=$(echo "$chosen" | sed 's/^[[:space:]]*//')

# Find the chosen layout's values and apply
for entry in "${LAYOUTS[@]}"; do
  name="${entry%%|*}"
  rest="${entry#*|}"
  layout="${rest%%|*}"
  variant="${rest##*|}"

  if [[ "$name" == "$chosen" ]]; then
    sed -i "s/^\([[:space:]]*kb_layout = \).*/\1$layout/" "$CONF"
    sed -i "s/^\([[:space:]]*kb_variant = \).*/\1$variant/" "$CONF"

    hyprctl reload

    notify-send "Keyboard Layout" "Switched to $name" --expire-time=2000 2>/dev/null || true

    exit 0
  fi
done
