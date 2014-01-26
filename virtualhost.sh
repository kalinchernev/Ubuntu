#!/bin/bash
clear
read -p "Project name: " project_name
echo "Creating $project_name ..."
# Creating project folder
sudo mkdir -p /var/www/$project_name/public_html
echo "Project folder has been created."
# Makes sure the user has permissions on the project folder
sudo chown -R $USER:$USER /var/www/$project_name/public_html
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
	<h1>Your project $project_name is ready to go!</h1>
	<p>The folder for your project is located at /var/www/$project_name/public_html</p>
	<p>Also a virtual host has been created at $project_name, so you can open it in your browser.</p>
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
</VirtualHost>
EOF

# Enabling the site at apache
sudo a2ensite $project_name
echo "Project $project_name site has been enabled at Apache."
sudo service apache2 restart
echo "Optional: set a value for the virtual host in the hosts files."
sudo chown $USER:$USER /etc/hosts
echo "127.0.0.1       $project_name" >> /etc/hosts
sudo service apache2 reload
echo "Apache has been reloaded and restarted"
echo "Project $project_name is ready!"