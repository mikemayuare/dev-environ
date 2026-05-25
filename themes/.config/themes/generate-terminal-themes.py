#!/usr/bin/env python3
"""Generate alacritty and kitty theme files for each theme folder.

Reads cosmic.ron (or swaync.css/waybar.css for TokyoNight-Day) and
produces alacritty (TOML) and kitty (conf) terminal colour themes.
"""

import os
import re
import sys
from pathlib import Path

THEMES_DIR = Path(os.path.dirname(os.path.abspath(__file__)))
NO_COSMIC = {"TokyoNight-Day"}


# ── TokyoNight-Day hardcoded palette (no cosmic.ron) ──
TOKYONIGHT_DAY = {
    "bg": "#e1e2e7",
    "fg": "#3760bf",
    "selection": "#d5d6db",
    "cursor": "#2e7de9",
    "color0": "#dddee3",
    "color1": "#c64343",
    "color2": "#49924e",
    "color3": "#8c6c3e",
    "color4": "#2e7de9",
    "color5": "#9854f1",
    "color6": "#0f978c",
    "color7": "#8c8fa1",
    "color8": "#c6c8d1",
    "color9": "#f52a65",
    "color10": "#6fae3a",
    "color11": "#a68a4a",
    "color12": "#3f8af0",
    "color13": "#a667f5",
    "color14": "#1eaaa0",
    "color15": "#a5a7b2",
    "dim0": "#b0b2ba",
    "dim1": "#9e3434",
    "dim2": "#3a7532",
    "dim3": "#715631",
    "dim4": "#2464ba",
    "dim5": "#7a43c0",
    "dim6": "#0c7970",
    "dim7": "#707281",
}


# ── helpers ──

def float_to_hex(r, g, b):
    return f"#{int(round(r * 255)):02x}{int(round(g * 255)):02x}{int(round(b * 255)):02x}"


def darken_hex(hx, factor):
    r = int(hx[1:3], 16)
    g = int(hx[3:5], 16)
    b = int(hx[5:7], 16)
    return f"#{int(r * factor):02x}{int(g * factor):02x}{int(b * factor):02x}"


# ── cosmic.ron parser ──

def parse_cosmic_ron(path):
    text = path.read_text()
    data = {}

    def extract(name):
        pat = rf'{name}:\s*\([^)]*red:\s*([\d.]+)[^)]*green:\s*([\d.]+)[^)]*blue:\s*([\d.]+)'
        m = re.search(pat, text)
        return (float(m.group(1)), float(m.group(2)), float(m.group(3))) if m else None

    def extract_opt(name):
        pat = rf'{name}:\s*Some\s*\(\([^)]*red:\s*([\d.]+)[^)]*green:\s*([\d.]+)[^)]*blue:\s*([\d.]+)'
        m = re.search(pat, text)
        return (float(m.group(1)), float(m.group(2)), float(m.group(3))) if m else None

    for i in range(11):
        v = extract(f"neutral_{i}")
        if v:
            data[f"neutral_{i}"] = v

    for key in ("accent_blue", "accent_indigo", "accent_green",
                "accent_yellow", "accent_orange", "accent_purple",
                "accent_pink", "accent_red",
                "bright_red", "bright_green", "bright_orange",
                "ext_orange", "ext_yellow", "ext_blue",
                "ext_purple", "ext_pink", "ext_indigo"):
        v = extract(key)
        if v:
            data[key] = v

    for key in ("bg_color", "primary_container_bg", "secondary_container_bg",
                "text_tint", "accent", "success", "warning", "destructive",
                "window_hint", "neutral_tint"):
        v = extract_opt(key)
        if v:
            data[key] = v

    return data


# ── colour value helpers ──

def gcol(data, *keys):
    """get first available colour tuple from data."""
    for k in keys:
        if k in data:
            return data[k]
    return None


def hx(col):
    return float_to_hex(*col)


# ── build palette ──

def neutral_sorted(data):
    """Return neutrals sorted by luminance ascending (dark to light)."""
    neutrals = [(k, v) for k, v in data.items()
                if k.startswith("neutral_") and isinstance(v, tuple)]
    neutrals.sort(key=lambda kv: 0.2126 * kv[1][0] + 0.7152 * kv[1][1] + 0.0722 * kv[1][2])
    return neutrals


def build_palette(data, is_dark):
    p = {}
    n_sorted = neutral_sorted(data)  # [(key, (r,g,b)), ...] dark→light
    n_dark = n_sorted[0][1] if n_sorted else None
    n_light = n_sorted[-1][1] if n_sorted else None

    # background / foreground
    p["bg"] = hx(gcol(data, "bg_color") or (n_dark if is_dark else n_light))
    p["fg"] = hx(gcol(data, "text_tint") or (n_light if is_dark else n_dark))

    # ANSI 16 — use luminance-sorted neutrals (always dark→light)
    p["color0"] = hx(n_sorted[1][1]) if len(n_sorted) >= 2 else hx(n_dark)
    p["color1"] = hx(gcol(data, "accent_red", "bright_red"))
    p["color2"] = hx(gcol(data, "accent_green", "bright_green"))
    p["color3"] = hx(gcol(data, "accent_yellow", "ext_yellow", "accent_orange"))
    p["color4"] = hx(gcol(data, "accent_blue", "ext_blue"))
    p["color5"] = hx(gcol(data, "accent_purple", "accent_pink", "accent_indigo"))
    p["color6"] = hx(gcol(data, "accent_indigo", "ext_indigo", "accent_blue"))
    p["color7"] = hx(n_sorted[-2][1]) if len(n_sorted) >= 2 else hx(n_light)

    # bright black (color8)
    if len(n_sorted) >= 4:
        p["color8"] = hx(n_sorted[3][1])
    elif len(n_sorted) >= 3:
        p["color8"] = hx(n_sorted[2][1])
    else:
        p["color8"] = p["color0"]

    p["color9"] = hx(gcol(data, "bright_red", "bright_orange",
                           "accent_orange", "accent_red"))
    p["color10"] = hx(gcol(data, "bright_green", "accent_green"))
    p["color11"] = hx(gcol(data, "ext_yellow", "accent_yellow",
                            "bright_orange", "accent_orange"))
    p["color12"] = hx(gcol(data, "ext_blue", "accent_blue"))
    p["color13"] = hx(gcol(data, "ext_purple", "ext_pink",
                            "accent_purple", "accent_indigo"))
    p["color14"] = hx(gcol(data, "ext_indigo", "accent_indigo", "accent_blue"))

    # bright white (color15)
    p["color15"] = hx(n_light)

    # selection / cursor
    sel = gcol(data, "primary_container_bg", "secondary_container_bg")
    if not sel and len(n_sorted) >= 3:
        sel = n_sorted[2][1]  # third neutral from dark end
    p["selection"] = hx(sel) if sel else p["color0"]

    cur = gcol(data, "window_hint", "accent")
    if not cur:
        cur = gcol(data, "text_tint") or n_light
    p["cursor"] = hx(cur)

    # dim colours
    for i in range(8):
        k = f"color{i}"
        if k in p:
            p[f"dim{i}"] = darken_hex(p[k], 0.78)

    return p


# ── generators ──

ALACRITTY_TPL = """# generated by generate-terminal-themes.py
[colors.primary]
background = "{bg}"
foreground = "{fg}"
dim_foreground = "{dim7}"

[colors.cursor]
text = "{bg}"
cursor = "{cursor}"

[colors.vi_mode_cursor]
text = "{bg}"
cursor = "{cursor}"

[colors.selection]
text = "CellForeground"
background = "{selection}"

[colors.search.matches]
foreground = "CellBackground"
background = "{color6}"

[colors.normal]
black = "{color0}"
red = "{color1}"
green = "{color2}"
yellow = "{color3}"
blue = "{color4}"
magenta = "{color5}"
cyan = "{color6}"
white = "{color7}"

[colors.bright]
black = "{color8}"
red = "{color9}"
green = "{color10}"
yellow = "{color11}"
blue = "{color12}"
magenta = "{color13}"
cyan = "{color14}"
white = "{color15}"

[colors.dim]
black = "{dim0}"
red = "{dim1}"
green = "{dim2}"
yellow = "{dim3}"
blue = "{dim4}"
magenta = "{dim5}"
cyan = "{dim6}"
white = "{dim7}"
"""

KITTY_TPL = """# generated by generate-terminal-themes.py
foreground              {fg}
background              {bg}
selection_foreground    {fg}
selection_background    {selection}
url_color               {color4}
cursor                  {cursor}
cursor_text_color       {bg}
active_border_color     {color5}
inactive_border_color   {color8}
bell_border_color       {color3}
wayland_titlebar_color system
macos_titlebar_color system
active_tab_foreground   {bg}
active_tab_background   {cursor}
inactive_tab_foreground {fg}
inactive_tab_background {color0}
tab_bar_background      {color0}
mark1_foreground {bg}
mark1_background {color4}
mark2_foreground {bg}
mark2_background {color5}
mark3_foreground {bg}
mark3_background {color6}
# The 16 terminal colours
color0 {color0}
color8 {color8}
color1 {color1}
color9 {color9}
color2 {color2}
color10 {color10}
color3 {color3}
color11 {color11}
color4 {color4}
color12 {color12}
color5 {color5}
color13 {color13}
color6 {color6}
color14 {color14}
color7 {color7}
color15 {color15}
"""


def write_theme(theme_dir, pal, name):
    al = ALACRITTY_TPL.format(**pal)
    kt = KITTY_TPL.format(**pal)
    (theme_dir / "alacritty").write_text(al)
    (theme_dir / "kitty").write_text(kt)
    print(f"  OK   {name:25s}  bg={pal['bg']}  fg={pal['fg']}  cursor={pal['cursor']}")


# ── main ──

def main():
    theme_dirs = sorted(d for d in THEMES_DIR.iterdir() if d.is_dir())
    errors = []

    for theme_dir in theme_dirs:
        name = theme_dir.name

        if name in NO_COSMIC:
            write_theme(theme_dir, TOKYONIGHT_DAY, name)
            continue

        cosmic = theme_dir / "cosmic.ron"
        if not cosmic.exists():
            print(f"  SKIP {name}: no cosmic.ron")
            continue

        data = parse_cosmic_ron(cosmic)
        if not data:
            print(f"  SKIP {name}: failed to parse cosmic.ron")
            continue

        mode_file = theme_dir / "mode"
        mode = "dark"
        if mode_file.exists():
            mode = mode_file.read_text().strip().lower()
        is_dark = mode == "dark"

        pal = build_palette(data, is_dark)

        # basic validation
        for k in ("bg", "fg", "color0", "color7", "cursor", "selection"):
            if not pal.get(k):
                errors.append(f"{name}: missing required key '{k}'")
                break
        else:
            write_theme(theme_dir, pal, name)

    if errors:
        print(f"\n{len(errors)} error(s):")
        for e in errors:
            print(f"  {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
