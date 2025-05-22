#!/bin/bash

set -e  # Exit on error

# --- Configuration ---
CLONE_DIR="$HOME/Niri-dot-files"
CONFIG_TARGET="$HOME/.config"
NIRI_SOURCE="$CLONE_DIR/.config/niri"
FUZZEL_SOURCE="$CLONE_DIR/.config/fuzzel"
NIRI_DEST="$HOME/niri"
FUZZEL_DEST="$HOME/fuzzel"
WALLPAPER_SOURCE="$NIRI_DEST/dotdark.png"
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

# --- Copy all dotfiles to ~/.config EXCEPT 'niri' and 'fuzzel' ---
echo "[+] Copying dotfiles to ~/.config/ (excluding 'niri' and 'fuzzel')..."
rsync -avh --exclude='.git' --exclude='niri' --exclude='fuzzel' "$CLONE_DIR/.config/" "$CONFIG_TARGET/"

# --- Copy 'niri' config to ~/niri ---
if [[ -d "$NIRI_SOURCE" ]]; then
    echo "[+] Copying 'niri' config to $NIRI_DEST..."
    rsync -avh "$NIRI_SOURCE/" "$NIRI_DEST/"
else
    echo "[!] Niri config not found at $NIRI_SOURCE. Skipping."
fi

# --- Copy 'fuzzel' config to ~/fuzzel ---
if [[ -d "$FUZZEL_SOURCE" ]]; then
    echo "[+] Copying 'fuzzel' config to $FUZZEL_DEST..."
    rsync -avh "$FUZZEL_SOURCE/" "$FUZZEL_DEST/"
else
    echo "[!] Fuzzel config not found at $FUZZEL_SOURCE. Skipping."
fi

# --- Copy wallpaper ---
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
