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

add_entry "  App Launcher" "$HOME/.config/rofi/launchers/app_drawer.sh"
add_entry "  Clipboard Manager" "$HOME/.config/rofi/launchers/clipboard.sh"
add_entry "  Internet Search" "$HOME/.config/rofi/launchers/internet_search.sh"
add_entry "  Settings" "$HOME/.config/rofi/launchers/settings.sh"
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
# Execute the chosen script
# ---------------------------------------------------------------------------
TARGET="${SCRIPTS[$CHOICE]}"

if [[ -z "$TARGET" ]]; then
  notify-send "Launcher" "No script mapped for: $CHOICE" --icon=dialog-error 2>/dev/null
  exit 1
fi

if [[ ! -x "$TARGET" ]]; then
  notify-send "Launcher" "Script not found or not executable:\n$TARGET" --icon=dialog-warning 2>/dev/null
  # Uncomment the line below to auto-chmod instead of erroring:
  # chmod +x "$TARGET" && bash "$TARGET"
  exit 1
fi

bash "$TARGET"
