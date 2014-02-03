#!/bin/bash
# File: SetupWebProject.sh
# Compatibility: Targeted for Ubuntu 13.10
# 
# Tired of setting up folders and files for every new virtual host at your environment? This script can help you.
# SetupWebProject.sh automates the setup of new web projects on Apache in the following way:
# * takes user input for name of the project - i.e. example.dev
# * creates a project folder at /var/www with input project name
# * creates an example file with HTML in the root folder of the newly created project folder
# * sets necessary permissions on new project files and folders to be editable
# * populates initial index.html file with HTML with welcoming instructions
# * setups the necessary folders at /etc/apache2 folders for new virtualhost project
# * enables the new virtualhost project site using default functions from apache2
# * includes a new entry inside /etc/hosts file for reaching the project with pretty url
# * restarts apache2 service

# Clear the screen
clear
# Take value for user project name
echo "Please enter desired name for your project, i.e. example.dev"
read -p "Project name: " project_name
echo "Creating $project_name ..."
# Creating project folder
sudo mkdir -p /var/www/$project_name/public_html
echo "Project folder has been created."
sudo mkdir -p /var/www/$project_name/logs
echo "Folder for log files has been created."
# Makes sure the user has permissions on the project folder
sudo chown -R $USER:$USER /var/www/$project_name/public_html
# Makes sure the user has permissions on the logs folder
sudo chown -R $USER:$USER /var/www/$project_name/logs
# Ensure anyone can read the files
sudo chmod -R 755 /var/www
# Creates and example index.html file in the project folder
touch /var/www/$project_name/public_html/index.html
# Take ownership over the project folder
sudo chown $USER:$USER /var/www/$project_name/public_html/index.html
# Create a starting file
cat <<EOF >> /var/www/$project_name/public_html/index.html
<html>
	<head>
	<title>$project_name index file</title>
</head>
<body>
<h1>$project_name is ready!</h1>
<p>This index file is located at: /var/www/$project_name/public_html/index.html<p>
<p>So. project folder is at: /var/www/$project_name/public_html</p>
<p>VirtualHost has been created with the name of your project: http://$project_name/</p>
<p>Happy coding!<p>
</body>
</html>
EOF
# Creates a new virtual host file
sudo touch /etc/apache2/sites-available/$project_name.conf
sudo chown $USER:$USER /etc/apache2/sites-available/$project_name.conf
cat <<EOF >> /etc/apache2/sites-available/$project_name.conf
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    ServerName $project_name
    ServerAlias www.$project_name
    DocumentRoot /var/www/$project_name/public_html
    <Directory />
        Options FollowSymLinks
        AllowOverride All
    </Directory>
    <Directory /var/www/>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Order allow,deny
        allow from all
    </Directory>
    ErrorLog /var/www/$project_name/logs/error.log
    CustomLog /var/www/$project_name/logs/access.log combined
</VirtualHost>
EOF

# Enabling the site at apache
sudo a2ensite $project_name
echo "Project $project_name site has been enabled at Apache."
sudo chown $USER:$USER /etc/hosts
# Includes a new entry in the /etc/hosts file
echo "127.0.0.1       $project_name" >> /etc/hosts
# Reloads apache2 service to take information for the new project
sudo service apache2 reload
echo "Apache service has been restarted."
echo "Project $project_name is ready!"
echo "It can be reached at this address: http://$project_name"
