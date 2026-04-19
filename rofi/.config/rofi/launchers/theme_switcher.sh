#!/usr/bin/env bash
# =============================================================================
#  themeswitcher.sh — Unified Theme Switcher
#  Switches: rofi · swaync · waybar · hyprland borders · ghostty
#
#  Theme dir structure:
#    ~/.config/themes/<n>/
#      swaync.css      → colors for swaync
#      waybar.css      → colors for waybar
#      hyprland.conf   → border colors for hyprland
#      ghostty         → built-in theme name (plain text, one line)
#    ~/.config/rofi/themes/<n>.rasi  → rofi theme
# =============================================================================

THEMES_DIR="$HOME/.config/themes"
ROFI_THEMES_DIR="$HOME/.config/themes"

ROFI_THEME_FILE="$HOME/.config/rofi/theme"
SWAYNC_COLORS="$HOME/.config/swaync/colors.css"
WAYBAR_COLORS="$HOME/.config/waybar/colors.css"
HYPR_COLORS="$HOME/.config/hypr/colors.conf"
GHOSTTY_CONFIG="$HOME/.config/ghostty/config"
CURRENT_FILE="$THEMES_DIR/current"

# ---------------------------------------------------------------------------
# Discover available themes
# ---------------------------------------------------------------------------
mapfile -t THEME_NAMES < <(find -L "$THEMES_DIR" -mindepth 1 -maxdepth 1 -type d -printf "%f\n" | sort)

if [[ ${#THEME_NAMES[@]} -eq 0 ]]; then
  notify-send "Theme Switcher" "No themes found in $THEMES_DIR" --icon=dialog-error 2>/dev/null
  exit 1
fi

CURRENT=$(cat "$CURRENT_FILE" 2>/dev/null)

# ---------------------------------------------------------------------------
# Build menu
# ---------------------------------------------------------------------------
MENU=$(for name in "${THEME_NAMES[@]}"; do
  if [[ "$name" == "$CURRENT" ]]; then
    echo "  $name"
  else
    echo "  $name"
  fi
done)

LINES=${#THEME_NAMES[@]}

if [[ -f "$ROFI_THEME_FILE" ]]; then
  ROFI_THEME=$(cat "$ROFI_THEME_FILE")
else
  ROFI_THEME=$(find "$ROFI_THEMES_DIR" -name "*.rasi" | sort | head -n1)
fi

# ---------------------------------------------------------------------------
# Show rofi
# ---------------------------------------------------------------------------
CHOICE=$(echo "$MENU" | rofi \
  -dmenu \
  -i \
  -p "  Theme" \
  -mesg "Active: ${CURRENT:-none}" \
  -theme "$ROFI_THEME" \
  -theme-str "listview { lines: $LINES; }" \
  -no-custom \
  -format s)

[[ -z "$CHOICE" ]] && exit 0

CHOSEN=$(echo "$CHOICE" | sed 's/^  *//')
THEME_PATH="$THEMES_DIR/$CHOSEN"
RASI="$THEME_PATH/$CHOSEN.rasi"

if [[ ! -d "$THEME_PATH" ]]; then
  notify-send "Theme Switcher" "Theme not found: $CHOSEN" --icon=dialog-error 2>/dev/null
  exit 1
fi

# ---------------------------------------------------------------------------
# Apply — copy color files into place
# ---------------------------------------------------------------------------
apply() {
  local src="$1" dst="$2" label="$3"
  if [[ -f "$src" ]]; then
    mkdir -p "$(dirname "$dst")"
    cp "$src" "$dst"
  else
    echo "Warning: $label not found at $src" >&2
  fi
}

apply "$THEME_PATH/swaync.css" "$SWAYNC_COLORS" "swaync colors"
apply "$THEME_PATH/waybar.css" "$WAYBAR_COLORS" "waybar colors"
apply "$THEME_PATH/hyprland.conf" "$HYPR_COLORS" "hyprland colors"

# rofi

if [[ -f "$RASI" ]]; then
  echo "$RASI" >"$ROFI_THEME_FILE"
else
  echo "Warning: No rofi theme found at $RASI — rofi theme unchanged" >&2
fi

# ghostty — read theme name from the theme folder AFTER CHOSEN is set, then patch config
GHOSTTY_THEME=$(cat "$THEME_PATH/ghostty" 2>/dev/null)
if [[ -n "$GHOSTTY_THEME" && -f "$GHOSTTY_CONFIG" ]]; then
  sed -i "s/^theme = .*/theme = $GHOSTTY_THEME/" "$GHOSTTY_CONFIG"
else
  [[ -z "$GHOSTTY_THEME" ]] && echo "Warning: no ghostty file in $THEME_PATH" >&2
  [[ ! -f "$GHOSTTY_CONFIG" ]] && echo "Warning: ghostty config not found at $GHOSTTY_CONFIG" >&2
fi

echo "$CHOSEN" >"$CURRENT_FILE"

# neovim
apply "$THEME_PATH/nvim-theme.lua" \
  "$HOME/.config/nvim/lua/plugins/theme.lua" \
  "nvim theme"

for socket in /run/user/$(id -u)/nvim.*.0 "$HOME"/.local/state/nvim/*.pipe; do
  [[ -S "$socket" ]] && nvim --server "$socket" --remote-send ':Lazy reload<CR>' 2>/dev/null
done

# color scheme mode
MODE=$(cat "$THEME_PATH/mode" 2>/dev/null)
if [[ "$MODE" == "light" ]]; then
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
elif [[ "$MODE" == "dark" ]]; then
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
fi

# Cosmic themes
COSMIC_RON="$THEME_PATH/cosmic.ron"
if [[ -f "$COSMIC_RON" ]]; then
  cosmic-settings appearance import "$COSMIC_RON" 2>/dev/null
fi

# ---------------------------------------------------------------------------
# Reload apps
# ---------------------------------------------------------------------------
killall swaync 2>/dev/null
pkill -SIGUSR2 waybar 2>/dev/null
hyprctl reload 2>/dev/null
killall -SIGUSR2 ghostty 2>/dev/null

notify-send "Theme Switcher" "Theme set to: $CHOSEN" --icon=preferences-desktop-theme 2>/dev/null
