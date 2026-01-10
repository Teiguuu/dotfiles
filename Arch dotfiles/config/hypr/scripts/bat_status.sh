#!/bin/bash
# Запускаем без sudo!
STATUS=$(/usr/bin/ideapad-cm status)

if [[ $STATUS == *"enabled"* ]]; then
    echo '{"text": "󰥔 80%", "class": "enabled"}'
else
    echo '{"text": "󰚥 100%", "class": "disabled"}'
fi
