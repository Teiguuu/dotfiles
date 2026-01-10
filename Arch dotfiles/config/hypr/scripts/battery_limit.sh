#!/bin/bash

# Получаем текущий статус
STATUS=$(/usr/bin/ideapad-cm status)

if [[ $STATUS == *"enabled"* ]]; then
    # Если включен лимит (80%), выключаем его (будет 100%)
    sudo /usr/bin/ideapad-cm disable ideapad_laptop
else
    # Если выключен, включаем (будет 80%)
    sudo /usr/bin/ideapad-cm enable ideapad_laptop
fi

# Обновляем waybar
pkill -RTMIN+8 waybar
