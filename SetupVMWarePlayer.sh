#!/bin/bash
# Project page: http://softwareupdate.vmware.com/cds/vmw-desktop/player/
# Documentation: http://www.vmware.com/products/player/
# File: SetupVMWarePlayer.sh
# Compatibility: Targeted for Ubuntu 13.10
# 
# The VMWare Player is "The Easiest Way to Run a Virtual Machine"
# Definitely better than VirtualBox.

# Clear the screen
clear

# Go to Desktop
cd ~/Desktop

echo "Downloading the player to your Desktop"
wget http://softwareupdate.vmware.com/cds/vmw-desktop/player/6.0.1/1379776/linux/core/VMware-Player-6.0.1-1379776.x86_64.bundle.tar

# Extracting the package
tar xvf VMware-Player-6.0.1-1379776.x86_64.bundle.tar

# Installing the package
sudo sh VMware-Player-6.0.1-1379776.x86_64.bundle

# Removing the installable files
echo "Removing installables from Desktop"
cd ~/Desktop
rm VMware-Player-6.0.1-1379776.x86_64.bundle
rm VMware-Player-6.0.1-1379776.x86_64.bundle.tar
rm descriptor.xml

echo "The setup is ready."
echo "Starting the application"
vmplayer