#!/usr/bin/env bash

# Rofi Monitor Resolution Picker for Hyprland with HDR and Bit Depth support
# Dependencies: rofi, jq, hyprland

# Configuration
MONITORS_CONFIG="$HOME/.config/hypr/lua/monitors.lua"
THEME_FILE=$(cat "$HOME/.config/rofi/theme")

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

# Extract hl.monitor({...}) block for a given monitor from lua config
get_lua_block() {
  local monitor="$1"
  if [[ ! -f "$MONITORS_CONFIG" ]]; then echo ""; return; fi
  awk -v mon="$monitor" '
    /^[[:space:]]*hl\.monitor\(\{/ { inb=1; buf=$0 "\n"; next }
    inb {
      buf=buf $0 "\n"
      if (/^[[:space:]]*\}\)/) {
        inb=0
        if (index(buf, "output = \"" mon "\"")) { printf "%s", buf; exit }
        buf=""
      }
    }
  ' "$MONITORS_CONFIG"
}

# Extract a field value from the lua monitor block
get_lua_field() {
  local monitor="$1" field="$2" default="$3"
  local block
  block=$(get_lua_block "$monitor")
  if [[ -z "$block" ]]; then echo "$default"; return; fi
  local val
  val=$(echo "$block" | grep -oP '^\s*'"$field"'\s*=\s*"?\K[^",\s]+' | head -1)
  echo "${val:-$default}"
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
    -hover-select \
    -me-select-entry '' \
    -me-accept-entry 'MousePrimary' \
    -format "s")

  [[ -z "$selected_monitor" ]] && exit 0
else
  selected_monitor="${monitors[0]}"
fi

echo "Selected monitor: $selected_monitor"

# Get current configuration for this monitor from lua
current_bitdepth=$(get_lua_field "$selected_monitor" "bitdepth" "8")
current_cm=$(get_lua_field "$selected_monitor" "cm" "auto")

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

# Track SDR values for hyprctl (set later if HDR configured)
sdr_brightness_val=""
sdr_saturation_val=""

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
    sdr_brightness_val=$(rofi -dmenu -i \
      -p "SDR Brightness (0.5-2.0, default 1.0)" \
      -theme "$THEME_FILE" \
      -format "s" \
      -mesg "Controls SDR content brightness in HDR mode")

    if [[ ! "$sdr_brightness_val" =~ ^[0-9]*\.?[0-9]+$ ]]; then
      sdr_brightness_val=""
    fi

    # SDR saturation (0.5 to 1.5, default 1.0)
    sdr_saturation_val=$(rofi -dmenu -i \
      -p "SDR Saturation (0.5-1.5, default 1.0)" \
      -theme "$THEME_FILE" \
      -format "s" \
      -mesg "Controls SDR content saturation in HDR mode")

    if [[ ! "$sdr_saturation_val" =~ ^[0-9]*\.?[0-9]+$ ]]; then
      sdr_saturation_val=""
    fi
  fi
fi

# Build lua monitor block with actual newlines
build_lua_block() {
  printf "hl.monitor({\n\toutput = \"%s\",\n\tmode = \"%s\",\n\tposition = \"auto\",\n\tscale = 1" "$selected_monitor" "$clean_resolution"
  [[ "$selected_bitdepth" != "8" ]] && printf ",\n\tbitdepth = %s" "$selected_bitdepth"
  [[ "$selected_cm" != "auto" ]] && printf ",\n\tcm = \"%s\"" "$selected_cm"
  [[ -n "$sdr_brightness_val" ]] && printf ",\n\tsdrbrightness = %s" "$sdr_brightness_val"
  [[ -n "$sdr_saturation_val" ]] && printf ",\n\tsdrsaturation = %s" "$sdr_saturation_val"
  printf "\n})\n"
}

new_block=$(build_lua_block)
echo "New monitor block:"
echo "$new_block"

# Update monitors.lua
update_lua_config() {
  local config="$1" monitor="$2" block="$3"
  local tmp="${config}.tmp" in_block=0 found=0 current=""

  if [[ ! -f "$config" ]]; then
    mkdir -p "$(dirname "$config")"
    printf '%s\n' "$block" > "$config"
    echo "Created new monitors.lua"
    return
  fi

  : > "$tmp"
  while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ $in_block -eq 0 ]] && [[ "$line" =~ ^[[:space:]]*hl\.monitor\(\{ ]]; then
      in_block=1
      current="$line"
    elif [[ $in_block -eq 1 ]]; then
      current+=$'\n'"$line"
      if [[ "$line" =~ ^[[:space:]]*\}\)[[:space:]]*$ ]]; then
        in_block=0
        if [[ "$current" == *"output = \"$monitor\""* ]]; then
          printf '%s\n' "$block" >> "$tmp"
          found=1
        else
          printf '%s\n' "$current" >> "$tmp"
        fi
        current=""
      fi
    else
      printf '%s\n' "$line" >> "$tmp"
    fi
  done < "$config"

  if [[ $found -eq 0 ]]; then
    printf '\n%s\n' "$block" >> "$tmp"
    echo "Added new monitor configuration"
  else
    echo "Updated existing monitor configuration"
  fi

  mv "$tmp" "$config"
}

update_lua_config "$MONITORS_CONFIG" "$selected_monitor" "$new_block"

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
if [[ -n "$sdr_brightness_val" ]]; then
  hyprctl_cmd+=",sdrbrightness,$sdr_brightness_val"
fi

if [[ -n "$sdr_saturation_val" ]]; then
  hyprctl_cmd+=",sdrsaturation,$sdr_saturation_val"
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
