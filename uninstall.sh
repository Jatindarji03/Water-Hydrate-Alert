#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
BOLD='\033[1m'
RESET='\033[0m'

echo ""
echo -e "${BLUE}${BOLD}💧 Water Hydrate Alert - Uninstaller${RESET}"
echo -e "${BLUE}──────────────────────────────────${RESET}"
echo ""

echo -e "  Stopping timer..."
systemctl --user stop water-alert.timer 2>/dev/null && echo -e "  ${GREEN}✓ Timer stopped${RESET}" || true
systemctl --user disable water-alert.timer 2>/dev/null && echo -e "  ${GREEN}✓ Timer disabled${RESET}" || true

echo -e "  Removing systemd files..."
rm -f ~/.config/systemd/user/water-alert.timer
rm -f ~/.config/systemd/user/water-alert.service
systemctl --user daemon-reload
echo -e "  ${GREEN}✓ systemd files removed${RESET}"

echo -e "  Removing alert script..."
rm -f ~/.local/bin/water-alert.sh
echo -e "  ${GREEN}✓ Script removed${RESET}"

echo ""
echo -e "  ${GREEN}${BOLD}✅ Uninstalled successfully!${RESET}"
echo -e "  ${RED}   Water Hydrate Alert has been removed.${RESET}"
echo ""