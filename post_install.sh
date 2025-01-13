#!/bin/bash

# Exit on errors
set -e

echo "Performing post-installation setup..."

# Enable multilib repository for AUR and Flatpak compatibility
echo "Enabling multilib repository..."
sed -i '/\[multilib\]/,/Include/s/^#//' /etc/pacman.conf
pacman -Syu --noconfirm

# Install Flatpak and enable Flathub
echo "Installing Flatpak and enabling Flathub..."
pacman -S --noconfirm flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install a graphical Flatpak store
echo "Installing graphical Flatpak store (GNOME Software)..."
pacman -S --noconfirm gnome-software-packagekit-plugin

# Alternatively, for KDE users:
# echo "Installing graphical Flatpak store (KDE Discover)..."
# pacman -S --noconfirm discover packagekit-qt5

# Install yay for AUR support
echo "Installing yay for AUR support..."
pacman -S --noconfirm git base-devel
cd /opt
git clone https://aur.archlinux.org/yay-bin.git
chown -R $USERNAME:$USERNAME yay-bin
cd yay-bin
sudo -u $USERNAME makepkg -si --noconfirm

# Install XFCE and LightDM
echo "Installing XFCE desktop environment..."
pacman -S --noconfirm xfce4 xfce4-goodies lightdm lightdm-gtk-greeter
systemctl enable lightdm

# Install additional utilities
echo "Installing additional utilities..."
pacman -S --noconfirm \
    firefox \
    vlc \
    htop \
    neofetch \
    unzip \
    p7zip

# Cleanup
echo "Cleaning up..."
rm -rf /opt/yay-bin

echo "Post-installation setup complete! Reboot to start using XFCE."
