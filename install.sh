#!/bin/bash

# Check if script is run with sudo
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo"
    exit 1
fi

echo "Installing High Tide dependencies and building application..."

# Update package lists
apt-get update

# Install required dependencies
echo "Installing system dependencies..."
apt-get install -y \
    gettext \
    python3-pip \
    libgtk-4-dev \
    libadwaita-1-dev \
    blueprint-compiler \
    meson \
    ninja-build \
    python3-gi \
    gir1.2-gtk-4.0 \
    gir1.2-adw-1 \
    libgstreamer1.0-0 \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-libav \
    python3-gst-1.0 \
    python3-gi-cairo \
    libgirepository1.0-dev \
    libcairo2-dev \
    pkg-config \
    python3-dev

# Install Python dependencies with proper flags
echo "Installing Python packages..."
python3 -m pip install --no-warn-script-location --break-system-packages tidalapi PyGObject

# Clean any existing build directory
echo "Cleaning build directory..."
rm -rf build/

# Setup build with Meson
echo "Setting up build with Meson..."
meson setup build

# Change to build directory and build
echo "Building application..."
cd build
ninja

# Install the application
echo "Installing application..."
ninja install

# Set executable permissions
echo "Setting permissions..."
chmod +x /usr/local/bin/HighTide

# Copy desktop file to applications directory
echo "Installing desktop entry..."
cp /usr/local/share/applications/io.github.nokse22.HighTide.desktop /usr/share/applications/

# Update desktop database
echo "Updating desktop database..."
update-desktop-database

echo "Installation complete! You can now launch High Tide from your applications menu"
echo "or run 'HighTide' from the terminal."

# Return to original directory
cd ..
