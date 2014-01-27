#!/bin/bash
# Drush project home page: http://drush.ws/
# Documentation pages: https://drupal.org/node/2132447
# File: SetupDrush.sh
# Compatibility: Targeted for Ubuntu 13.10
# 
# Drush is a command line tool for Drupal.
# It completes many tasks faster and easier. More info at project site.

# Clear the screen
clear

# Installing PEAR
sudo apt-get install php-pear
# Finding Drush on PEAR
sudo pear channel-discover pear.drush.org
# Installing Drush
sudo pear install drush/drush
# Fixes for Drush on Ubuntu 13.10
sudo apt-get install php5-json
# Creating the folder
mkdir ~/.drush
# Copying php,ini configurations at Drush configurations folder
cp /etc/php5/cli/php.ini ~/.drush/
# Giving information to the user
echo "Open ~/.drush/php.ini file and EMPTY up the disable_functions variable!"
# Opening the PHP configurations file at Drush to clear the list of disabled functions
sudo nano ~/.drush/php.ini
cd ~/Desktop
# Downloading dependency to Console_Table-1.1.3.tgz
wget http://download.pear.php.net/package/Console_Table-1.1.3.tgz
# Extract the package
tar -zxvf Console_Table-1.1.3.tgz
# Copy the package to /usr/share/php/drush/lib
sudo cp -r Console_Table-1.1.3/ /usr/share/php/drush/lib/

echo "Success! You are ready to use Drush!"
