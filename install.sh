#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
RESET='\033[0m'

GITHUB_RAW="https://raw.githubusercontent.com/Jatindarji03/Water-Hydrate-Alert/main"

echo ""
echo -e "${CYAN}${BOLD}"
echo "  💧  Water Hydrate Alert"
echo "      Linux Installer"
echo -e "${RESET}${BLUE}  ──────────────────────────────────${RESET}"
echo ""

# ---- Ask reminder interval ----
echo -e "  ${BOLD}How often do you want a reminder?${RESET}"
echo ""
echo -e "    ${CYAN}1)${RESET} Every 30 minutes"
echo -e "    ${CYAN}2)${RESET} Every 45 minutes"
echo ""
read -p "  Enter 1 or 2: " CHOICE

if [ "$CHOICE" = "1" ]; then
    INTERVAL="30min"
    echo -e "  ${GREEN}✓ Reminder set to every 30 minutes${RESET}"
elif [ "$CHOICE" = "2" ]; then
    INTERVAL="45min"
    echo -e "  ${GREEN}✓ Reminder set to every 45 minutes${RESET}"
else
    echo -e "  ${RED}✗ Invalid choice. Defaulting to 30 minutes.${RESET}"
    INTERVAL="30min"
fi

echo ""

# ----  Install zenity ----
echo -e "  ${YELLOW}[1/4]${RESET} Checking zenity..."

if command -v zenity &>/dev/null; then
    echo -e "        ${GREEN}✓ Already installed${RESET}"
else
    echo -e "        Installing zenity..."
    if command -v apt &>/dev/null; then
        sudo apt install -y zenity 2>/dev/null
    elif command -v dnf &>/dev/null; then
        sudo dnf install -y zenity 2>/dev/null
    elif command -v pacman &>/dev/null; then
        sudo pacman -S --noconfirm zenity 2>/dev/null
    elif command -v zypper &>/dev/null; then
        sudo zypper install -y zenity 2>/dev/null
    else
        echo -e "        ${RED}✗ Unknown package manager.${RESET}"
        echo -e "        Please install 'zenity' manually then re-run."
        exit 1
    fi
    echo -e "        ${GREEN}✓ zenity installed${RESET}"
fi

# ----  Download alert script ----
echo -e "  ${YELLOW}[2/4]${RESET} Installing alert script..."

mkdir -p ~/.local/bin
curl -fsSL "$GITHUB_RAW/water-alert.sh" -o ~/.local/bin/water-alert.sh
chmod +x ~/.local/bin/water-alert.sh

echo -e "        ${GREEN}✓ Script saved to ~/.local/bin/water-alert.sh${RESET}"

# ----  Create systemd service & timer ----
echo -e "  ${YELLOW}[3/4]${RESET} Setting up systemd timer..."

mkdir -p ~/.config/systemd/user

cat > ~/.config/systemd/user/water-alert.service << 'SEOF'
[Unit]
Description=Water Hydrate Alert

[Service]
Type=oneshot
ExecStart=%h/.local/bin/water-alert.sh
PassEnvironment=DISPLAY DBUS_SESSION_BUS_ADDRESS XAUTHORITY
SEOF

cat > ~/.config/systemd/user/water-alert.timer << SEOF
[Unit]
Description=Water Hydrate Alert Timer (every $INTERVAL)

[Timer]
OnBootSec=5min
OnUnitActiveSec=$INTERVAL
Unit=water-alert.service

[Install]
WantedBy=timers.target
SEOF

echo -e "        ${GREEN}✓ systemd timer set to $INTERVAL${RESET}"

# ----  Enable & start ----
echo -e "  ${YELLOW}[4/4]${RESET} Enabling timer..."

systemctl --user daemon-reload
systemctl --user enable water-alert.timer 2>/dev/null || true
systemctl --user start water-alert.timer

echo -e "        ${GREEN}✓ Timer enabled & started${RESET}"

echo ""
echo -e "  ${BLUE}──────────────────────────────────${RESET}"
echo -e "  ${GREEN}${BOLD}✅ Installation complete!${RESET}"
echo -e "  ${CYAN}   Reminder set every ${INTERVAL}.${RESET}"
echo -e "  ${CYAN}   Popup stays open until you click OK!${RESET}"
echo ""
echo -e "  ${BOLD}Useful commands:${RESET}"
echo -e "  ${BLUE}  Test now   →${RESET} bash ~/.local/bin/water-alert.sh"
echo -e "  ${BLUE}  Stop       →${RESET} systemctl --user stop water-alert.timer"
echo -e "  ${BLUE}  Uninstall  →${RESET} curl -fsSL $GITHUB_RAW/uninstall.sh | bash"
echo ""