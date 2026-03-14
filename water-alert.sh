#!/bin/bash


export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

MESSAGES=(
    "Time to drink water! Stay hydrated. 💧"
    "Hydration check! Grab a glass of water. 🥤"
    "30 minutes passed — drink some water! 💦"
    "Your body needs water. Drink up! 🌊"
    "Water break! Keep yourself hydrated. 🫗"
    "Boost your energy — drink water now! ⚡"
    "Brain needs water! Take a sip. 🧠"
)

MSG="${MESSAGES[$RANDOM % ${#MESSAGES[@]}]}"

if ! command -v zenity &>/dev/null; then
    sudo apt install -y zenity 2>/dev/null
fi

zenity --info \
    --title="💧 Hydrate Alert" \
    --text="$MSG" \
    --width=300 \
    --height=150 \
    --ok-label="✅ Done, I drank water!"