#!/bin/bash
# Project home page: 
# Documentation pages: 
# File: BackupWebProject.sh
# 
# Creates a backup for all web projects in a given environment
# In current example, ~/Copy/Backup folder is used, automatically synched with Copy cloud service

today=$(date +"%d-%m-%Y")
file="$today.backup.tar.gz"

echo "Backing up web projects to ~/Copy/Backup/automatic/$file file, please wait..."

cd ~/Copy/Backup/automatic

tar -zcvpf $file /var/www/

echo "Backup complete!"