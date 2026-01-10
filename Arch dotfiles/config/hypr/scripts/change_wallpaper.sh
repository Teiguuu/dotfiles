#!/bin/bash

# Путь к папке с твоими обоями
DIR="$HOME/Pictures/oboi/Обои"
# Файл для хранения индекса текущих обоев
INDEX_FILE="/tmp/wallpaper_index"

# Создаем файл индекса, если его нет
if [ ! -f "$INDEX_FILE" ]; then
    echo 0 > "$INDEX_FILE"
fi

# Собираем все картинки в массив
mapfile -t WALLPAPERS < <(find "$DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) | sort)

# Читаем текущий индекс
INDEX=$(cat "$INDEX_FILE")

# Проверяем, не вышел ли индекс за пределы массива
if [ "$INDEX" -ge "${#WALLPAPERS[@]}" ]; then
    INDEX=0
fi

# Выбираем текущие обои
WALLPAPER="${WALLPAPERS[$INDEX]}"

# Меняем обои через swww
swww img "$WALLPAPER" --transition-type center --transition-step 90

# Генерируем палитру через pywal
wal -i "$WALLPAPER"

# --- ОБНОВЛЕНИЕ КОНФИГОВ ПОД ЦВЕТА ---

# 1. Обновляем CAVA (копируем из шаблона pywal в конфиг)
# Генерируем палитру
wal -i "$WALLPAPER"

# Проверяем, создался ли кэш, и только потом копируем
if [ -f "$HOME/.cache/wal/cava" ]; then
    cp "$HOME/.cache/wal/cava" "$HOME/.config/cava/config"
else
    notify-send "Ошибка" "Шаблон CAVA не найден в кэше Pywal"
fi

# Перезагружаем CAVA (отправляем сигнал для обновления цветов без закрытия)
pkill -USR1 cava || true

# 2. Обновляем WOFI (копируем стиль из шаблона)
cp ~/.cache/wal/wofi.css ~/.config/wofi/style.css
pkill wofi

# 3. Перезапускаем Waybar, чтобы обновить цвета полоски
killall waybar && waybar &

# --- КОНЕЦ ОБНОВЛЕНИЯ ---

# Увеличиваем индекс для следующего раза
NEXT_INDEX=$(( (INDEX + 1) % ${#WALLPAPERS[@]} ))
echo "$NEXT_INDEX" > "$INDEX_FILE"

notify-send "Wallpaper Changed" "Enjoy your new look!"

cp ~/.cache/wal/colors-hyprlock.conf ~/.config/hypr/colors-hyprlock.conf

# --- УЛЬТИМАТИВНЫЙ ПЛАВНЫЙ БЛОК ---

# 1. Генерируем палитру
wal -i "$WALLPAPER" -q

# 2. Обновляем Kitty (без перезапуска)
killall -USR1 kitty 2>/dev/null

# 3. ПЕРЕЗАГРУЖАЕМ СТИЛЬ WAYBAR БЕЗ ЕГО ВЫКЛЮЧЕНИЯ
# Сигнал SIGUSR2 заставляет Waybar перечитать CSS файл
pkill -SIGUSR2 waybar

# 4. Обновляем tty-clock
for term in /dev/pts/[0-9]*; do
    cat ~/.cache/wal/sequences > "$term" 2>/dev/null
done
