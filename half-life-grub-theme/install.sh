#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "❌ Error: Please run this script as root (sudo ./install.sh)"
  exit 1
fi

echo "============================"
echo "   Half-Life GRUB Theme Installer"
echo "============================"
echo "Select your theme variant:"
echo "1) Hazard Orange (#fe5a02)"
echo "2) Lambda Crimson (#a91408)"
read -p "Enter choice [1 or 2]: " choice

THEME_DIR="/boot/grub/themes/half-life"
rm -rf "$THEME_DIR"
mkdir -p "$THEME_DIR"

if [ "$choice" -eq 1 ]; then
    echo "⏳ Installing Hazard Orange variant..."
    cp -r variant_orange/* "$THEME_DIR/"
elif [ "$choice" -eq 2 ]; then
    echo "⏳ Installing Lambda Crimson variant..."
    cp -r variant_crimson/* "$THEME_DIR/"
else
    echo "❌ Invalid choice. Exiting."
    exit 1
fi

GRUB_CONFIG="/etc/default/grub"
if grep -q "GRUB_THEME=" "$GRUB_CONFIG"; then
    sed -i 's|^#\?GRUB_THEME=.*|GRUB_THEME="/boot/grub/themes/half-life/theme.txt"|' "$GRUB_CONFIG"
else
    echo 'GRUB_THEME="/boot/grub/themes/half-life/theme.txt"' >> "$GRUB_CONFIG"
fi

echo "Refreshing GRUB configurations..."
if command -v update-grub &> /dev/null; then
    update-grub
elif command -v grub-mkconfig &> /dev/null; then
    grub-mkconfig -o /boot/grub/grub.cfg
fi

echo "✅ Installation complete."
