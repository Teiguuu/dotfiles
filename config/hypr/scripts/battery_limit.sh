#!/bin/bash
if [ "$1" == "80" ]; then
    sudo /usr/bin/ideapad-cm enable ideapad_laptop
elif [ "$1" == "100" ]; then
    sudo /usr/bin/ideapad-cm disable ideapad_laptop
fi
pkill -RTMIN+8 waybar
