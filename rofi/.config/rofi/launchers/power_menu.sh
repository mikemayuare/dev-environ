#!/usr/bin/env bash
# =============================================================================
#  powermenu.sh — Nord-themed Rofi Power Menu
#  Uses loginctl (elogind) — compatible with OpenRC
#  Theme: ~/.config/rofi/themes/nord-launcher.rasi
# =============================================================================

THEME=$(cat "$HOME/.config/rofi/theme")

# ---------------------------------------------------------------------------
# Entries — icon + label : loginctl command
# ---------------------------------------------------------------------------
POWEROFF="  Power Off"
RESTART="  Restart"
SUSPEND="  Suspend"

MENU=$(printf '%s\n' "$SUSPEND" "$RESTART" "$POWEROFF")

LINES=$(echo "$MENU" | wc -l)
# ---------------------------------------------------------------------------
# Show rofi
# ---------------------------------------------------------------------------
CHOICE=$(echo "$MENU" | rofi \
  -dmenu \
  -i \
  -p "  Power" \
  -theme "$THEME" \
  -theme-str "listview { lines: $LINES; }" \
  -no-custom \
  -format s)

[[ -z "$CHOICE" ]] && exit 0

# ---------------------------------------------------------------------------
# Confirm helper — shows a yes/no prompt for destructive actions
# ---------------------------------------------------------------------------
confirm() {
  local msg="$1"
  printf 'Yes\nNo' | rofi \
    -dmenu \
    -i \
    -p "  Confirm" \
    -mesg "$msg" \
    -theme "$THEME" \
    -no-custom \
    -format s \
    -lines 2 \
    -no-fixed-num-lines
}

# ---------------------------------------------------------------------------
# Execute
# ---------------------------------------------------------------------------
case "$CHOICE" in
"$POWEROFF")
  ans=$(confirm "Power off the system?")
  [[ "$ans" == "Yes" ]] && loginctl poweroff
  ;;
"$RESTART")
  ans=$(confirm "Restart the system?")
  [[ "$ans" == "Yes" ]] && loginctl reboot
  ;;
"$SUSPEND")
  loginctl suspend
  ;;
esac
