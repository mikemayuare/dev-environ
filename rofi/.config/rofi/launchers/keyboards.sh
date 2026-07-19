#!/usr/bin/env bash

# Keyboard layout switcher for Hyprland
# Switches between English US and English US International

THEME=$(cat "$HOME/.config/rofi/theme")

# Layout definitions: index maps to kb_layout entry in input.lua
LAYOUTS=(
  "English US"
  "English US International"
)
LINES=${#LAYOUTS[@]}

# Get current active keymap to detect which layout is active
active_keymap=$(hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .active_keymap')

# If keymap name contains "Intl", we're on international layout (index 1)
current_idx=0
if echo "$active_keymap" | grep -qi "intl"; then
  current_idx=1
fi

# Build rofi menu entries, marking the active layout
menu_entries=""
for i in "${!LAYOUTS[@]}"; do
  name="${LAYOUTS[$i]}"
  if [[ "$i" == "$current_idx" ]]; then
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

# Find chosen layout and switch by index
for i in "${!LAYOUTS[@]}"; do
  if [[ "${LAYOUTS[$i]}" == "$chosen" ]]; then
    hyprctl switchxkblayout all "$i"

    notify-send "Keyboard Layout" "Switched to ${LAYOUTS[$i]}" --expire-time=2000 2>/dev/null || true

    exit 0
  fi
done
