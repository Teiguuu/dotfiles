#!/bin/bash
# Проверяем, играет ли что-то
if playerctl status > /dev/null 2>&1; then
    # Выводим название трека (обрезаем до 40 символов, чтобы не вылезло за экран)
    playerctl metadata --format "{{ title }}" | cut -c1-40
else
    # Если ничего не играет — выводим пустую строку
    echo ""
fi
