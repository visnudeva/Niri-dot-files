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
PACKAGES=(yay niri waybar fuzzel swaybg swayidle gvfs geany blueman nwg-look mako kitty
xdg-desktop-portal-gtk xdg-desktop-portal-gnome gnome-keyring nautilus)
AUR_PACKAGES=(ttf-nerd-fonts-symbols swaylock-effects qogir-cursor-theme qogir-icon-theme qogir-gtk-theme)

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

# --- message ---
echo "[✔] Dotfiles and packages installed successfully!"

# --- Set SDDM and LightDM background from Hypr config image ---
LOGIN_WALL="$HOME/.config/hypr/burreddot.png"

# Set background for SDDM (if installed)
if command -v sddm &>/dev/null; then
    echo "[+] Setting SDDM background..."
    SDDM_THEME_DIR="/usr/share/sddm/themes"
    THEME_CONF=$(find "$SDDM_THEME_DIR" -name theme.conf 2>/dev/null | head -n 1)
    if [[ -f "$THEME_CONF" ]]; then
        sudo sed -i "s|^Background=.*|Background=$LOGIN_WALL|" "$THEME_CONF" || echo "Background=$LOGIN_WALL" | sudo tee -a "$THEME_CONF"
        echo "[✔] SDDM background set to $LOGIN_WALL"
    else
        echo "[!] Could not find SDDM theme.conf. Background not set."
    fi
fi

# Set background for LightDM GTK greeter (if installed)
if command -v lightdm &>/dev/null && [[ -f /etc/lightdm/lightdm-gtk-greeter.conf ]]; then
    echo "[+] Setting LightDM GTK greeter background..."
    sudo sed -i "s|^background=.*|background=$LOGIN_WALL|" /etc/lightdm/lightdm-gtk-greeter.conf || echo "background=$LOGIN_WALL" | sudo tee -a /etc/lightdm/lightdm-gtk-greeter.conf
    echo "[✔] LightDM background set to $LOGIN_WALL"
fi

# --- Final message ---
echo -e "\n All done! Your Arch/Niri setup is now rocking with fresh dotfiles, packages, and a slick login screen. Enjoy the smooth vibes! \n"
