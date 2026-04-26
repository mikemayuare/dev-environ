#!/usr/bin/env bash
# =============================================================================
#  search.sh — Rofi Multi-Engine Web Search
#  Prefixes: dd = DuckDuckGo (default), gg = Google, yt = YouTube
# =============================================================================
THEME=$(cat "$HOME/.config/rofi/theme")

query=$(
  rofi \
    -dmenu \
    -p "  Search" \
    -theme "$THEME" \
    -theme-str "listview { lines: 0; }entry { placeholder: '  type to search...'; }"
)

[ -z "$query" ] && exit 0

# Detect engine prefix (e.g. "yt cats falling")
case "$query" in
"gg "*)
  engine="Google"
  term="${query#gg }"
  base="https://www.google.com/search?q="
  ;;
"yt "*)
  engine="YouTube"
  term="${query#yt }"
  base="https://www.youtube.com/results?search_query="
  ;;
"gh "*)
  engine="GitHub"
  term="${query#gh }"
  base="https://github.com/search?q="
  ;;
"rd "*)
  engine="Reddit"
  term="${query#rd }"
  base="https://www.reddit.com/search/?q="
  ;;
"dd "*)
  engine="DuckDuckGo"
  term="${query#dd }"
  base="https://duckduckgo.com/?q="
  ;;
*)
  engine="DuckDuckGo"
  term="$query"
  base="https://duckduckgo.com/?q="
  ;;
esac

encoded=$(python3 -c "import urllib.parse, sys; print(urllib.parse.quote(sys.argv[1]))" "$term")

xdg-open "${base}${encoded}"
