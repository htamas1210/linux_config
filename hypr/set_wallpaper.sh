#!/usr/bin/env bash
sleep 0.5

WALLPAPER_DIR="$HOME/Pictures/Wallpaper/"
CURRENT_WALLPAPERS=$(hyprctl hyprpaper listloaded)

WALLPAPER=$(find "$WALLPAPER_DIR" -type f ! -name "$(basename "$CURRENT_WALLPAPER")" | grep -v .git | shuf -n 1)
echo $WALLPAPER
hyprctl hyprpaper wallpaper "eDP-1, $WALLPAPER ,"
hyprctl hyprpaper wallpaper "HDMI-A-1, $WALLPAPER ,"
