#!/bin/bash
echo "Configuring Intel Graphics..."

# Create Intel configuration file
sudo mkdir -p /etc/X11/xorg.conf.d
sudo tee /etc/X11/xorg.conf.d/20-intel.conf > /dev/null <<EOF
Section "Device"
    Identifier  "Intel Graphics"
    Driver      "intel"
    Option      "TearFree"    "true"
    Option      "AccelMethod" "sna"
    Option      "DRI"         "3"
EndSection
EOF

# Install VA-API drivers
echo "Installing VA-API for Intel Graphics..."
sudo pacman -S --noconfirm libva-intel-driver libva-utils

echo "Intel Graphics configuration completed. Please reboot for changes to take effect."
