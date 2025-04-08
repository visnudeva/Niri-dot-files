**Here is my simple niri dotfiles setup.**
If you don't know how it works, here is how i do it to make it the easiest possible.

I install EndeavourOs which is an Arch Linux based distro and choose I3 as a Window Manager, once installed i install all these
sudo pacman -S niri kitty waybar dunst fuzzel swaybg hyprlock hypridle thunar thunar-volman gvfs nerd-fonts geany blueman

As endeavourOS has disabled the bluetooth for security reasons here is how to enable it if you need it
sudo systemctl enable bluetooth
sudo systemctl enable --now bluetooth

you can now dowload my .config folder, 
then open your file manager, do CTRL+h to show the hidden files in your home folder, 
then copy the dowloaded .config folder over the one in your home folder and overwrite if asked.

If you want to use my wallpaper 
sudo cp ~/.config/niri/dotdark.png /usr/share/endeavouros/backgrounds

If you want to replace the lightdm background which is the display manager (login)
sudo nano /etc/lightdm/slick-greeter.conf
and change the background line for this
/usr/share/endeavouros/backgrounds/dotdark.png

Now you can logout and login on niri instead of I3.

The keyboard layout is US but it can also be changed in the niri config file.

The main keybindings are:
     
    - Mod+T kitty (terminal)
    - Mod+I geany (IDE)
    - Mod+M fuzzel (launcher)
    - Mod+W firefox (web browser)
    - Mod+F thunar (file browser)
    - Mod+L hyprlock (lock)
    - Mod+E Exit (logout)
    
![screenshot1](https://github.com/visnudeva/Niri-dot-files/blob/main/screenshot.png)
![screenshot1](https://github.com/visnudeva/Niri-dot-files/blob/main/screenshot2.png)

