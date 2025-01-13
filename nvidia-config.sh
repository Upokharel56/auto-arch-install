#!/bin/bash

# Exit on errors
set -e

echo "Installing NVIDIA drivers and utilities..."
pacman -S --noconfirm nvidia nvidia-utils nvidia-settings

echo "NVIDIA setup complete!"
