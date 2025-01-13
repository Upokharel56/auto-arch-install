#!/bin/bash

# Exit on errors
set -e

# Variables
DISK_PART="/dev/sdXn"    # Replace with your 200GB partition
EFI_PART="/dev/sdYn"     # Replace with your EFI partition
HOSTNAME="arch"
USERNAME="Rip hunter"    # Default username
PASSWORD="3010"          # Default password

# Mount partitions
echo "Mounting partitions..."
mount "$DISK_PART" /mnt
mkdir -p /mnt/boot
mount "$EFI_PART" /mnt/boot

# Install base system
echo "Installing base system..."
pacstrap /mnt base linux linux-firmware base-devel nano networkmanager

# Generate fstab
echo "Generating fstab..."
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot into the new system
arch-chroot /mnt /bin/bash <<EOF

# Set hostname
echo "$HOSTNAME" > /etc/hostname
cat <<EOT >> /etc/hosts
127.0.0.1   localhost
::1         localhost
127.0.1.1   $HOSTNAME.localdomain $HOSTNAME
EOT

# Set root password
echo "Setting default root password..."
echo "root:$PASSWORD" | chpasswd

# Create a new user with default credentials
echo "Creating user '$USERNAME' with default password..."
useradd -m -G wheel -s /bin/bash "$USERNAME"
echo "$USERNAME:$PASSWORD" | chpasswd

# Enable sudo for the user
pacman -S --noconfirm sudo
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

EOF

# Proceed with further steps (e.g., grub installation, post-installation script)


# Ask user for optional configurations
read -p "Do you need extra NVIDIA configuration? Default [yes]: " nvidia_config
nvidia_config=${nvidia_config:-yes}

if [[ "$nvidia_config" =~ ^(yes|y|YES|Y)?$ ]]; then
  echo "Fetching NVIDIA configuration script..."
  curl -LO https://raw.githubusercontent.com/yourusername/repo/main/nvidia-config.sh
  chmod +x nvidia-config.sh
  ./nvidia-config.sh
fi

read -p "Do you need Intel-specific configurations? Default [yes]: " intel_config
intel_config=${intel_config:-yes}

if [[ "$intel_config" =~ ^(yes|y|YES|Y)?$ ]]; then
  echo "Fetching Intel configuration script..."
  curl -LO https://raw.githubusercontent.com/yourusername/repo/main/intel-config.sh
  chmod +x intel-config.sh
  ./intel-config.sh
fi

# Install GRUB
arch-chroot /mnt /bin/bash <<EOF
pacman -S --noconfirm grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=Arch
grub-mkconfig -o /boot/grub/grub.cfg
EOF

# Unmount partitions and finish
echo "Unmounting partitions..."
umount -R /mnt

echo "Installation complete. Reboot now."
