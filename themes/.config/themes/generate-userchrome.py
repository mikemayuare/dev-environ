#!/usr/bin/env python3
"""Generate userChrome.css for each theme folder.

Reads cosmic.ron (or swaync.css/waybar.css as fallback for TokyoNight-Day)
and produces a Zen Browser userChrome.css with the theme's colors.
"""

import os
import re
import sys
from pathlib import Path

THEMES_DIR = Path(os.path.dirname(os.path.abspath(__file__)))
NO_COSMIC = {"TokyoNight-Day"}

THEME_NAME = {
    "Catppuccin-Frappe": "Catppuccin Frappe",
    "Catppuccin-Latte": "Catppuccin Latte",
    "Catppuccin-Macchiato": "Catppuccin Macchiato",
    "Catppuccin-Mocha": "Catppuccin Mocha",
    "Everforest-Dark": "Everforest Dark",
    "Everforest-Light": "Everforest Light",
    "Gruvbox-Dark": "Gruvbox Dark",
    "Gruvbox-Light": "Gruvbox Light",
    "Kanagawa-Dragon": "Kanagawa Dragon",
    "Kanagawa-Lotus": "Kanagawa Lotus",
    "Kanagawa-Wave": "Kanagawa Wave",
    "Nord": "Nord",
    "Osaka-Jade": "Osaka Jade",
    "Retro-82": "Retro-82",
    "Rose-Pine": "Rose Pine",
    "Rose-Pine-Dawn": "Rose Pine Dawn",
    "Rose-Pine-Moon": "Rose Pine Moon",
    "TokyoNight-Day": "TokyoNight Day",
    "TokyoNight-Night": "TokyoNight Night",
}


def float_to_hex(r, g, b):
    return f"#{int(round(r * 255)):02x}{int(round(g * 255)):02x}{int(round(b * 255)):02x}"


def darken_hex(hx, factor):
    r = int(hx[1:3], 16)
    g = int(hx[3:5], 16)
    b = int(hx[5:7], 16)
    return f"#{int(r * factor):02x}{int(g * factor):02x}{int(b * factor):02x}"


def luminance(r, g, b):
    return 0.2126 * r + 0.7152 * g + 0.0722 * b


def parse_cosmic_ron(path):
    text = path.read_text()
    data = {}

    def extract_color(name):
        pat = rf'{name}:\s*\([^)]*red:\s*([\d.]+)[^)]*green:\s*([\d.]+)[^)]*blue:\s*([\d.]+)'
        m = re.search(pat, text)
        if m:
            return (float(m.group(1)), float(m.group(2)), float(m.group(3)))
        return None

    def extract_optional(name):
        pat = rf'{name}:\s*Some\s*\(\([^)]*red:\s*([\d.]+)[^)]*green:\s*([\d.]+)[^)]*blue:\s*([\d.]+)'
        m = re.search(pat, text)
        if m:
            return (float(m.group(1)), float(m.group(2)), float(m.group(3)))
        return None

    for key in ["bg_color", "primary_container_bg", "accent", "success",
                "window_hint", "text_tint"]:
        val = extract_optional(key)
        if val:
            data[key] = val

    for i in range(11):
        val = extract_color(f"neutral_{i}")
        if val:
            data[f"neutral_{i}"] = val

    for key in ["accent_blue", "accent_indigo", "accent_green",
                "accent_yellow", "accent_orange", "accent_purple", "accent_pink"]:
        val = extract_color(key)
        if val:
            data[key] = val

    return data


def parse_swaync_waybar(theme_dir):
    colors = {}
    swaync = theme_dir / "swaync.css"
    if swaync.exists():
        for m in re.finditer(r'--(\w+):\s*(#[0-9a-fA-F]{6})\s*;', swaync.read_text()):
            colors[m.group(1)] = m.group(2)
    waybar = theme_dir / "waybar.css"
    if waybar.exists():
        for m in re.finditer(r'@define-color\s+(\w+)\s+(#[0-9a-fA-F]{6});', waybar.read_text()):
            colors[m.group(1)] = m.group(2)
    return colors


TEMPLATE = """/* {theme_name} — Zen Browser chrome */

:root {{
    --chrome-bg: {bg} !important;
    --chrome-container: {container} !important;
    --chrome-accent: {accent} !important;
    --chrome-text: {text} !important;
    --chrome-secondary: {secondary} !important;

    --zen-main-browser-background: var(--chrome-bg) !important;
    --zen-sidebar-background: var(--chrome-bg) !important;
    --zen-navigator-toolbox-background: var(--chrome-bg) !important;
    --zen-browser-generic-background: var(--chrome-bg) !important;
}}

#zen-sidebar-container,
#sidebar-box,
#TabsToolbar,
#navigation-toolbox,
.zen-sidebar-workspace-container {{
    background-color: var(--chrome-bg) !important;
    appearance: none !important;
}}

#zen-sidebar-container {{
    padding: 0 !important;
    margin: 0 !important;
}}

tab {{
    font-family: "JetBrains Mono", monospace !important;
    border-radius: 0px !important;
    margin: 0 !important;
}}

tab[selected="true"] .tab-background {{
    background-color: var(--chrome-container) !important;
    border-left: 3px solid var(--chrome-secondary) !important;
    box-shadow: none !important;
}}

tab[selected="true"] .tab-label {{
    color: var(--chrome-secondary) !important;
}}

#urlbar-background {{
    background-color: {urlbar_bg} !important;
    border: 1px solid var(--chrome-container) !important;
}}

#urlbar-input {{
    color: var(--chrome-accent) !important;
    font-family: "JetBrains Mono", monospace !important;
}}

toolbar#nav-bar {{
    background-color: var(--chrome-bg) !important;
    box-shadow: none !important;
}}

* {{
    border-radius: 2px !important;
    text-shadow: none !important;
    box-shadow: none !important;
}}
"""


def get_theme_colors(theme_dir, theme_name):
    if theme_name in NO_COSMIC:
        pal = parse_swaync_waybar(theme_dir)
        return {
            "bg": pal.get("base", "#e1e2e7"),
            "container": pal.get("surface0", "#d5d6db"),
            "accent": pal.get("accent", "#2e7de9"),
            "text": pal.get("text", "#3760bf"),
            "secondary": pal.get("highlight", "#9854f1"),
        }

    cosmic = theme_dir / "cosmic.ron"
    if not cosmic.exists():
        return None

    d = parse_cosmic_ron(cosmic)

    bg = d.get("bg_color") or d.get("neutral_0", (0, 0, 0))
    bg_hex = float_to_hex(*bg)

    container = d.get("primary_container_bg")
    if not container:
        bg_rgb = d.get("bg_color")
        for i in [2, 1, 0, 3]:
            cand = d.get(f"neutral_{i}")
            if cand and (bg_rgb is None or cand != bg_rgb):
                container = cand
                break
    if not container:
        container = (0.1, 0.1, 0.1)
    container_hex = float_to_hex(*container)

    accent = d.get("accent") or d.get("accent_blue") or d.get("window_hint", (0.5, 0.5, 0.5))
    accent_hex = float_to_hex(*accent)

    text = d.get("text_tint") or d.get("neutral_10", (1, 1, 1))
    text_hex = float_to_hex(*text)

    secondary = (d.get("success") or d.get("window_hint")
                 or d.get("accent_indigo") or d.get("neutral_6", (0.5, 0.5, 0.5)))
    secondary_hex = float_to_hex(*secondary)

    return {
        "bg": bg_hex,
        "container": container_hex,
        "accent": accent_hex,
        "text": text_hex,
        "secondary": secondary_hex,
    }


def main():
    theme_names = sorted(THEME_NAME)
    errors = []

    for name in theme_names:
        theme_dir = THEMES_DIR / name
        if not theme_dir.is_dir():
            print(f"  SKIP {name}: directory not found")
            continue

        colors = get_theme_colors(theme_dir, name)
        if colors is None:
            print(f"  SKIP {name}: no cosmic.ron and not in fallback list")
            continue

        lum = luminance(
            int(colors["bg"][1:3], 16) / 255,
            int(colors["bg"][3:5], 16) / 255,
            int(colors["bg"][5:7], 16) / 255,
        )
        dark_factor = 0.6 if lum < 0.5 else 0.85
        urlbar_bg = darken_hex(colors["bg"], dark_factor)

        rendered = TEMPLATE.format(
            theme_name=THEME_NAME[name],
            **colors,
            urlbar_bg=urlbar_bg,
        )

        out_path = theme_dir / "userChrome.css"
        out_path.write_text(rendered.strip() + "\n")
        print(f"  OK   {name:25s} bg={colors['bg']} container={colors['container']} accent={colors['accent']} secondary={colors['secondary']}")

    if errors:
        print(f"\n{len(errors)} error(s):")
        for e in errors:
            print(f"  {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
