#!/bin/bash

set -e  # Exit on error

# --- Configuration ---
REPO_URL="https://github.com/visnudeva/Niri-dot-files.git"
CLONE_DIR="$HOME/niri-dotfiles"
CONFIG_TARGET="$HOME/.config"
PACKAGES=(yay niri kitty waybar dunst fuzzel swaybg hyprlock hypridle thunar thunar-volman gvfs geany blueman)
AUR_PACKAGES=(ttf-nerd-fonts-symbols)

# --- Clone the repository ---
echo "[+] Cloning your GitHub repo to $CLONE_DIR..."
git clone "$REPO_URL" "$CLONE_DIR"

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
echo "[+] Copying dotfiles to ~/.config/..."
rsync -avh --exclude='.git' "$CLONE_DIR/.config/" "$CONFIG_TARGET/"

# --- Final message ---
echo "[✔] Dotfiles and packages installed successfully!"
