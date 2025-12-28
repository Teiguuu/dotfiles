#!/bin/bash
DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"
NAME="$DIR/screenshot_$(date +%d%m%Y_%H%M%S).png"

grim -g "$(slurp)" "$NAME" && wl-copy < "$NAME" && notify-send "Скриншот сохранен" "Файл: $NAME"
