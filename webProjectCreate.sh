#!/bin/bash
project_name=$1
echo $project_name
# Creating project folder
sudo mkdir -p /var/www/$project_name/public_html
echo "Project folder has been created."
# Makes sure the user has permissions on the project folder
sudo chown -R $USER:$USER /var/www/$project_name/public_html
# Ensure anyone can read the files
sudo chmod -R 755 /var/www
# Creates and example index.html file in the project folder
sudo touch /var/www/$project_name/public_html/index.html
echo "Your project has been created successfully" >> /var/www/$project_name/public_html/index.html
# Creates a new virtual host file
sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/$project_name.conf
sudo chown $USER:$USER /etc/apache2/sites-available/$project_name.conf
echo "Configure the project"
sudo nano /etc/apache2/sites-available/$project_name.conf
# Enabling the site at apache
sudo a2ensite $project_name
echo "Enabled site"
sudo service apache2 restart
echo "127.0.0.1       $project_name" >> /etc/hosts
sudo service apache2 reload
echo "Apache has been reloaded and restarted"
echo "Project $project_name is ready!"
