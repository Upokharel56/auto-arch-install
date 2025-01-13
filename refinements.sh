#!/bin/bash

# Exit on errors
set -e

echo "Starting system refinements..."

### Appearance Section
echo "### Appearance Section ###"
echo "Installing fonts and improving appearance..."
pacman -S --noconfirm ttf-dejavu ttf-liberation noto-fonts ttf-roboto ttf-ubuntu-font-family noto-fonts-cjk noto-fonts-emoji noto-fonts-extra
echo "### Appearance Section Ends ###"

### Battery Management
echo "### Battery Management Section ###"
echo "Installing power management tools..."
pacman -S --noconfirm tlp tlp-rdw acpi
systemctl enable tlp

# Adding TLP GUI for ease
echo "Installing TLP GUI..."
yay -S --noconfirm tlpui
echo "### Battery Management Section Ends ###"

### Additional Utilities
echo "Installing additional utilities and optimizations..."
# Optimus Manager for GPU switching
yay -S --noconfirm optimus-manager

# System Monitoring and Sensors
pacman -S --noconfirm sysstat lm_sensors hddtemp
systemctl enable lm_sensors

# Audio Setup (PipeWire)
pacman -S --noconfirm pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber

# Networking and File Sharing
pacman -S --noconfirm networkmanager wpa_supplicant samba
systemctl enable NetworkManager smb

# Printer and Scanner Support
pacman -S --noconfirm cups hplip sane
systemctl enable cups

# Firewall
pacman -S --noconfirm ufw
ufw enable
ufw default deny incoming
ufw default allow outgoing

# Preload for performance improvement
pacman -S --noconfirm preload
systemctl enable preload

### XFCE Desktop Extras
echo "Installing XFCE desktop extras..."
pacman -S --noconfirm xfce4-notifyd xfce4-taskmanager xfce4-power-manager

### Cleanup
echo "Cleaning up unnecessary files..."
pacman -Scc --noconfirm

echo "System refinements complete! Reboot for all changes to take effect."
