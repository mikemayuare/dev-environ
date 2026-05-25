#!/usr/bin/env bash
# =============================================================================
#  launcher.sh — Nord-themed Rofi Hub Launcher
#  Theme: ~/.config/rofi/themes/nord-launcher.rasi
# =============================================================================

THEME=$(cat "$HOME/.config/rofi/theme")

# ---------------------------------------------------------------------------
# Menu entries — format:  "ICON  Display Label"
# Add or remove entries freely. Icons are Nerd Font glyphs (optional).
# ---------------------------------------------------------------------------
declare -A SCRIPTS    # maps label → script path
declare -a MENU_ORDER # preserves display order

add_entry() { # add_entry "ICON  Label" "/path/to/script.sh"
  local label="$1"
  local script="$2"
  SCRIPTS["$label"]="$script"
  MENU_ORDER+=("$label")
}

# ── Edit entries below ──────────────────────────────────────────────────────
#  add_entry "ICON  Friendly Name"   "/path/to/your/script.sh"

add_entry "  Settings" "$HOME/.config/rofi/launchers/settings.sh"
add_entry "  App Launcher" "$HOME/.config/rofi/launchers/app_drawer.sh"
add_entry "  Clipboard Manager" "$HOME/.config/rofi/launchers/clipboard.sh"
add_entry "  Internet Search" "$HOME/.config/rofi/launchers/internet_search.sh"
add_entry "  Reload Hyprland" "/usr/bin/hyprctl reload"
add_entry "  Power Menu" "$HOME/.config/rofi/launchers/power_menu.sh"

# ── End of entries ──────────────────────────────────────────────────────────

# ---------------------------------------------------------------------------
# Build the menu string
# ---------------------------------------------------------------------------
MENU=$(printf '%s\n' "${MENU_ORDER[@]}")
LINES=$(echo "$MENU" | wc -l)
# ---------------------------------------------------------------------------
# Show rofi
# ---------------------------------------------------------------------------
CHOICE=$(echo "$MENU" | rofi \
  -dmenu \
  -i \
  -p "  Main Menu" \
  -theme "$THEME" \
  -theme-str "listview { lines: $LINES; }" \
  -hover-select \
  -me-select-entry '' \
  -me-accept-entry 'MousePrimary' \
  -no-custom \
  -format s)

# Abort if nothing was selected (Esc / no match)
[[ -z "$CHOICE" ]] && exit 0

# ---------------------------------------------------------------------------
# Execute the chosen script or command
# ---------------------------------------------------------------------------
TARGET="${SCRIPTS[$CHOICE]}"

# Abort if no target found
[[ -z "$TARGET" ]] && exit 1

# Check if the target is a file on disk
if [[ -f "$TARGET" ]]; then
  # If it's a file, make sure it's executable and run it
  if [[ -x "$TARGET" ]]; then
    bash "$TARGET"
  else
    notify-send "Launcher" "Script not executable: $TARGET" --icon=dialog-warning
    exit 1
  fi
else
  # If it's NOT a file, treat it as a raw command (like hyprctl reload)
  eval "$TARGET"
fi
