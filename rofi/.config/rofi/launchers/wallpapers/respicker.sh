#!/bin/bash

# Rofi Monitor Resolution Picker for Hyprland with HDR and Bit Depth support
# Dependencies: rofi, jq, hyprland

# Configuration
MONITORS_CONFIG="$HOME/.config/hypr/monitors.conf"
THEME_FILE="$HOME/.config/rofi/launchers/wallpapers/respicker-nord.rasi"

# Fallback resolutions for main monitor if detection fails
FALLBACK_RESOLUTIONS=(
  "3440x1440@120"
  "3440x1440@60"
  "2560x1440@60"
  "2560x1080@60"
  "1920x1080@60"
)

# Bit depth options
BIT_DEPTHS=("8" "10")

# Color management (cm) options
CM_OPTIONS=(
  "auto:Auto (sRGB for 8-bit, Wide for 10-bit)"
  "srgb:sRGB (Standard)"
  "wide:Wide Color Gamut (BT2020)"
  "hdr:HDR (Wide + HDR PQ)"
  "hdredid:HDR with EDID Primaries"
  "dcip3:DCI-P3"
  "adobe:Adobe RGB"
)

# Function to get all monitors
get_monitors() {
  hyprctl monitors all -j | jq -r '.[].name'
}

# Function to get available modes for a monitor
get_available_modes() {
  local monitor="$1"
  local modes=$(hyprctl monitors all -j | jq -r ".[] | select(.name == \"$monitor\") | .availableModes[]")

  if [[ -z "$modes" ]]; then
    echo "Error: Could not detect modes for $monitor" >&2
    return 1
  fi

  echo "$modes"
}

# Function to format resolution string
format_resolution() {
  local mode="$1"
  # Parse: "3440x1440@119.998001Hz"
  local res=$(echo "$mode" | sed -E 's/@([0-9]+\.[0-9]+)Hz/@\1Hz/' | sed -E 's/@([0-9]+)\..*Hz/ @ \1Hz/')
  echo "$res"
}

# Function to get current monitor configuration
get_current_config() {
  local monitor="$1"
  if [[ -f "$MONITORS_CONFIG" ]]; then
    grep "^monitor = $monitor," "$MONITORS_CONFIG" || echo ""
  fi
}

# Function to extract current bit depth from config
get_current_bitdepth() {
  local config_line="$1"
  if [[ "$config_line" =~ bitdepth[[:space:]]*,[[:space:]]*([0-9]+) ]]; then
    echo "${BASH_REMATCH[1]}"
  else
    echo "8" # Default
  fi
}

# Function to extract current cm from config
get_current_cm() {
  local config_line="$1"
  if [[ "$config_line" =~ cm[[:space:]]*,[[:space:]]*([a-z0-9]+) ]]; then
    echo "${BASH_REMATCH[1]}"
  else
    echo "auto" # Default
  fi
}

# Check if Hyprland is running
if ! pgrep -x Hyprland >/dev/null; then
  notify-send "Error" "Hyprland is not running" -u critical
  exit 1
fi

# Get all monitors
mapfile -t monitors < <(get_monitors)

if [[ ${#monitors[@]} -eq 0 ]]; then
  notify-send "Error" "No monitors detected" -u critical
  exit 1
fi

# Select monitor if more than one
selected_monitor=""
if [[ ${#monitors[@]} -gt 1 ]]; then
  # Show monitor picker
  monitor_list=$(printf '%s\n' "${monitors[@]}")
  selected_monitor=$(echo "$monitor_list" | rofi -dmenu -i \
    -p "Select Monitor" \
    -theme "$THEME_FILE" \
    -format "s")

  [[ -z "$selected_monitor" ]] && exit 0
else
  selected_monitor="${monitors[0]}"
fi

echo "Selected monitor: $selected_monitor"

# Get current configuration for this monitor
current_config=$(get_current_config "$selected_monitor")
current_bitdepth=$(get_current_bitdepth "$current_config")
current_cm=$(get_current_cm "$current_config")

echo "Current bit depth: $current_bitdepth"
echo "Current color management: $current_cm"

# Get available resolutions for the selected monitor
available_modes=$(get_available_modes "$selected_monitor")

if [[ $? -ne 0 ]] || [[ -z "$available_modes" ]]; then
  echo "Warning: Could not detect resolutions, using fallback list"
  # Use fallback resolutions
  resolution_list=$(printf '%s\n' "${FALLBACK_RESOLUTIONS[@]}")
else
  # Parse and format available modes
  resolution_list=""
  while IFS= read -r mode; do
    formatted=$(format_resolution "$mode")
    resolution_list+="$formatted"$'\n'
  done <<<"$available_modes"
fi

# Remove duplicates and sort by resolution (descending)
resolution_list=$(echo "$resolution_list" | sort -t'x' -k1 -nr -k2 -nr | uniq)

# Show resolution picker
selected_resolution=$(echo "$resolution_list" | rofi -dmenu -i \
  -p "Select Resolution for $selected_monitor" \
  -theme "$THEME_FILE" \
  -format "s")

[[ -z "$selected_resolution" ]] && exit 0

# Clean up the resolution format for hyprland config
# Convert "3440x1440 @ 120Hz" to "3440x1440@120"
clean_resolution=$(echo "$selected_resolution" | sed 's/ @ /@/' | sed 's/Hz$//')

echo "Selected resolution: $clean_resolution"

# Ask for bit depth
bitdepth_list=$(printf '%s\n' "${BIT_DEPTHS[@]}")
# Highlight current bit depth
bitdepth_list_with_current=$(echo "$bitdepth_list" | sed "s/^${current_bitdepth}$/${current_bitdepth} (current)/")

selected_bitdepth=$(echo "$bitdepth_list_with_current" | rofi -dmenu -i \
  -p "Select Bit Depth" \
  -theme "$THEME_FILE" \
  -format "s" \
  -mesg "8-bit: Standard | 10-bit: Better color (HDR/Wide gamut)")

# If cancelled, use current bit depth
if [[ -z "$selected_bitdepth" ]]; then
  selected_bitdepth="$current_bitdepth"
else
  # Remove " (current)" suffix if present
  selected_bitdepth=$(echo "$selected_bitdepth" | sed 's/ (current)$//')
fi

echo "Selected bit depth: $selected_bitdepth"

# Ask for color management
cm_list=""
for option in "${CM_OPTIONS[@]}"; do
  key="${option%%:*}"
  desc="${option#*:}"
  # Highlight current cm
  if [[ "$key" == "$current_cm" ]]; then
    cm_list+="$desc (current)"$'\n'
  else
    cm_list+="$desc"$'\n'
  fi
done

selected_cm_desc=$(echo "$cm_list" | rofi -dmenu -i \
  -p "Select Color Management" \
  -theme "$THEME_FILE" \
  -format "s" \
  -mesg "HDR requires compatible monitor and 10-bit depth")

# If cancelled, use current cm
if [[ -z "$selected_cm_desc" ]]; then
  selected_cm="$current_cm"
else
  # Remove " (current)" suffix if present
  selected_cm_desc=$(echo "$selected_cm_desc" | sed 's/ (current)$//')
  # Extract the key from the description
  for option in "${CM_OPTIONS[@]}"; do
    key="${option%%:*}"
    desc="${option#*:}"
    if [[ "$desc" == "$selected_cm_desc" ]]; then
      selected_cm="$key"
      break
    fi
  done
fi

echo "Selected color management: $selected_cm"

# Build the monitor configuration line
monitor_line="monitor = $selected_monitor, $clean_resolution, auto, 1"

# Add bit depth if not default (8)
if [[ "$selected_bitdepth" != "8" ]]; then
  monitor_line+=", bitdepth, $selected_bitdepth"
fi

# Add color management if not auto
if [[ "$selected_cm" != "auto" ]]; then
  monitor_line+=", cm, $selected_cm"
fi

# If HDR is selected, optionally add SDR brightness/saturation controls
if [[ "$selected_cm" == "hdr" ]] || [[ "$selected_cm" == "hdredid" ]]; then
  # Ask if user wants to configure SDR brightness/saturation
  configure_sdr=$(echo -e "No\nYes" | rofi -dmenu -i \
    -p "Configure SDR brightness/saturation for HDR mode?" \
    -theme "$THEME_FILE" \
    -format "s" \
    -mesg "Optional: Adjust SDR content appearance in HDR mode")

  if [[ "$configure_sdr" == "Yes" ]]; then
    # SDR brightness (0.5 to 2.0, default 1.0)
    sdr_brightness=$(rofi -dmenu -i \
      -p "SDR Brightness (0.5-2.0, default 1.0)" \
      -theme "$THEME_FILE" \
      -format "s" \
      -mesg "Controls SDR content brightness in HDR mode")

    if [[ -n "$sdr_brightness" ]] && [[ "$sdr_brightness" =~ ^[0-9]*\.?[0-9]+$ ]]; then
      monitor_line+=", sdrbrightness, $sdr_brightness"
    fi

    # SDR saturation (0.5 to 1.5, default 1.0)
    sdr_saturation=$(rofi -dmenu -i \
      -p "SDR Saturation (0.5-1.5, default 1.0)" \
      -theme "$THEME_FILE" \
      -format "s" \
      -mesg "Controls SDR content saturation in HDR mode")

    if [[ -n "$sdr_saturation" ]] && [[ "$sdr_saturation" =~ ^[0-9]*\.?[0-9]+$ ]]; then
      monitor_line+=", sdrsaturation, $sdr_saturation"
    fi
  fi
fi

echo "Final monitor line: $monitor_line"

# Update monitors.conf
if [[ -f "$MONITORS_CONFIG" ]]; then
  # Check if there's already a line for this monitor
  if grep -q "^monitor = $selected_monitor," "$MONITORS_CONFIG"; then
    # Replace existing line
    sed -i "s|^monitor = $selected_monitor,.*|$monitor_line|" "$MONITORS_CONFIG"
    echo "Updated existing monitor configuration"
  else
    # Add new line
    echo "$monitor_line" >>"$MONITORS_CONFIG"
    echo "Added new monitor configuration"
  fi
else
  # Create new config file
  mkdir -p "$(dirname "$MONITORS_CONFIG")"
  echo "# Monitor configuration" >"$MONITORS_CONFIG"
  echo "$monitor_line" >>"$MONITORS_CONFIG"
  echo "Created new monitors.conf"
fi

# Apply the change immediately using hyprctl
echo "Applying changes..."

# Build hyprctl command (slightly different syntax)
hyprctl_cmd="$selected_monitor,$clean_resolution,auto,1"

if [[ "$selected_bitdepth" != "8" ]]; then
  hyprctl_cmd+=",bitdepth,$selected_bitdepth"
fi

if [[ "$selected_cm" != "auto" ]]; then
  hyprctl_cmd+=",cm,$selected_cm"
fi

# Add SDR settings if they were configured
if [[ "$monitor_line" =~ sdrbrightness ]]; then
  sdr_brightness=$(echo "$monitor_line" | grep -oP 'sdrbrightness, \K[0-9.]+')
  hyprctl_cmd+=",sdrbrightness,$sdr_brightness"
fi

if [[ "$monitor_line" =~ sdrsaturation ]]; then
  sdr_saturation=$(echo "$monitor_line" | grep -oP 'sdrsaturation, \K[0-9.]+')
  hyprctl_cmd+=",sdrsaturation,$sdr_saturation"
fi

hyprctl keyword monitor "$hyprctl_cmd"

if [[ $? -eq 0 ]]; then
  # Build notification message
  notify_msg="Monitor: $selected_monitor\nResolution: $selected_resolution\nBit Depth: ${selected_bitdepth}-bit"

  if [[ "$selected_cm" != "auto" ]]; then
    notify_msg+="\nColor: $selected_cm"
  fi

  notify-send "Display Settings Applied" "$notify_msg" -i video-display
  echo "Successfully applied all settings"
else
  notify-send "Warning" "Settings saved but may require Hyprland reload\nTry: hyprctl reload" -u normal -i video-display
  echo "Warning: hyprctl command failed, may need to reload Hyprland"
fi
