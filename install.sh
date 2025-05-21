#!/bin/bash

set -e  # Exit on error

# --- Configuration ---
CLONE_DIR="$HOME/Niri-dot-files"
CONFIG_TARGET="$HOME/.config"
WALLPAPER_SOURCE="$CONFIG_TARGET/niri/dotdark.png"
WALLPAPER_DEST="/usr/share/endeavouros/backgrounds"
PACKAGES=(yay niri kitty waybar dunst fuzzel swaybg hyprlock hypridle thunar thunar-volman gvfs geany blueman)
AUR_PACKAGES=(ttf-nerd-fonts-symbols)

# --- Install necessary packages ---
echo "[+] Installing packages with pacman..."
sudo pacman -Syu --noconfirm "${PACKAGES[@]}"

# --- Install AUR packages if yay is available ---
if command -v yay &>/dev/null; then
    echo "[+] Installing AUR packages with yay..."
    yay -S --noconfirm "${AUR_PACKAGES[@]}"
else
    echo "[!] 'yay' not found. Skipping AUR package installation: ${AUR_PACKAGES[*]}"
fi

# --- Copy dotfiles to ~/.config ---
echo "[+] Copying dotfiles from $CLONE_DIR/.config/ to $CONFIG_TARGET/..."
rsync -avh --exclude='.git' "$CLONE_DIR/.config/" "$CONFIG_TARGET/"

# --- Set wallpaper ---
if [[ -f "$WALLPAPER_SOURCE" ]]; then
    echo "[+] Copying wallpaper to $WALLPAPER_DEST..."
    sudo mkdir -p "$WALLPAPER_DEST"
    sudo cp "$WALLPAPER_SOURCE" "$WALLPAPER_DEST"
    echo "[✔] Wallpaper installed."
else
    echo "[!] Wallpaper not found at $WALLPAPER_SOURCE. Skipping wallpaper setup."
fi

# --- Final message ---
echo "[✔] Dotfiles and packages installed successfully!"
