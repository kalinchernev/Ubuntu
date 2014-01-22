#!/bin/bash
# Start this script at newly installed Ubuntu 12.04 LTS
# The script will install all necessary software for setting up a web development environment
# 
# Ubuntu fixes
# - Install the package to fix missing skype icon on toolbar
# 
# LAMP environment
# - apache2
# - php5
# - mysql
# - phpmyadmin
# - set apache files to use home directory as public_html
# - configuration files for virtual hosts are in each folder
# 
# Automation
# - setup new virtual host+alias for web project
# 
# Include aliases
# - starting apache service
# - restarting apache service
# - installing packages through aptitute
# - removing packages through aptitude
# - updating and upgrading through aptitude
# 
# Install packages through aptitude
# - git
# - subversion (SVN)
# - VirtualBox
# 
# Get external apps
# - Skype
# - Google Chrome
# - DropBox
# - Sublime Text 3
# - Netbeans
# - Copy
# - XDebug
# 
# Adding external repos
# - NodeJS
# - Drush
#
# @Todo
# - include a function to download, extract and start Copy app and move it to /opt folder
# - include a function to install Apps from external sources (Drush, nodejs, themes, icons)
# - Include drush installation
# - Include NodeJS installation
# - Include XDebug installation
# - Include XDebug installation
# - Automation: include a function to setup a new project
# - Automation: include a .bash_aliases file at home directory
# - Finish the file with a question to run the upgrade command
# - make an initial check if the system is indeed Ubuntu 12.04 LTS before running the script?

# The script is targeted for Ubuntu 12.04 LTS

###################################
# FUNCTIONS AND LIST DEFINITIONS #
##################################

# Includes 3 line breaks in the command line
function consoleBreak {
    printf "\n\n\n"
}

# Function to get file extension
# Will be used to determine how to install a package from the folder with downloaded external apps
function getPackageExtension () {
    echo $1|awk -F . '{print $NF}'
}

function listExternalApps () {
    printf "\n"
    echo "This is the list of external apps to be installed: "
    for i in "${!appsList[@]}"
    do
        echo "$i"
    done
    consoleBreak
}

function listRepositoryApps () {
    printf "\n"
    echo "This is the list of repository apps to be installed: "
    for i in "${!repoAppsList[@]}"
    do
        echo "$i"
    done
    consoleBreak
}

function createExternalAppsFolder {
    cd ~/Desktop/
    mkdir ExternalApps
    cd ExternalApps
    printf "\n"
    echo "A foldre ExternalApps has been created on your Desktop. Apps will be downloaded there."
    printf "\n"
}

function downloadExternalApps () {
    cd ~/Desktop/ExternalApps
    echo "Starting the download of external apps ..."
    for i in "${!appsList[@]}"
    do
        echo "Downloading $i ..."
        printf "\n"
        wget ${appsList[$i]}
    done
}

function listDirectoryFiles () {
    printf "\n"
    echo "You are here: "
    pwd
    printf "\n"
    echo "These are the files available: "
    files=(*)
    for i in "${!files[@]}"
    do
        echo ${files[$i]}
    done
    printf "\n\n\n"
}

function installDirectoryFiles () {
    files=(*)   
    for i in "${!files[@]}"
    do
        echo "Opening:"
        echo ${files[$i]}
        extension=$(getPackageExtension ${files[$i]})
        echo "This file is of extension:"
        echo $extension;
        if [ "$extension" = "sh" ]; then
            chmod +x ${files[$i]}
            ./${files[$i]}
        else
            sudo dpkg -i ${files[$i]}
        fi
    done
}


function InstallRepositoryApps () {
    echo "Starting the installation of apps from repositories"
    sudo apt-get update
    for i in "${!repoAppsList[@]}"
    do
        echo "Installing $i ..."
        printf "\n"
        sudo apt-get install ${repoAppsList[$i]}
    done
}

# Declaring an array with list of external apps
declare -A appsList

appsList=(
    ["NetBeans for PHP and HTML5"]="http://download.netbeans.org/netbeans/7.4/final/bundles/netbeans-7.4-php-linux.sh"
    ["Google Chrome for Ubuntu 12.04 LTS 64 bit"]="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    ["DrobBox for Ubuntu 12.04 LTS 64 bit "]="https://linux.dropbox.com/packages/ubuntu/dropbox_1.6.0_amd64.deb"
    ["Skype for Ubuntu 12.04 LTS Multiachitecture"]="http://download.skype.com/linux/skype-ubuntu-precise_4.2.0.11-1_i386.deb"
    ["SublimeText3 Beta for Ubuntu 12.04 LTS 64 bit"]="http://c758482.r82.cf2.rackcdn.com/sublime-text_build-3059_amd64.deb"
)

# Declaring an array with list of repository apps
declare -A repoAppsList

repoAppsList=(
    ["Apache2 Server"]="apache2"
    ["MySQL Server"]="mysql-server libapache2-mod-auth-mysql php5-mysql mysql-client-core-5.5"
    ["PHP5"]="php5 libapache2-mod-php5 php5-mcrypt"
    ["PHP5 Extensions"]="php5-mysql php5-curl php5-gd php-pear php5-mcrypt php5-recode php5-sqlite"
    ["phpmyadmin"]="phpmyadmin"
    ["git"]="git"
    ["SVN"]="subversion libapache2-svn"
    ["VirtualBox"]="virtualbox"
    ["Gnome Tweak Tool"]="gnome-tweak-tool"
)


############################
# STARTING THE ACTUAL WORK #
############################
consoleBreak
echo "Will install the JDK7 package now. It's needed by NetBeans ..."

# Installing JDK7 which is needed by NetBeans
sudo apt-get install python-software-properties
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java7-installer

# Creating a folder on user's Desktop to download the external apps
createExternalAppsFolder
# Downloading the apps
downloadExternalApps appsList
# Tell the user which apps will be installed
listExternalApps appsList
# @Todo include a function to install the packages depending on the .deb or .sh extensions

cd ~/Desktop/ExternalApps

# get all files in the folder
files=(*)
# list the files
listDirectoryFiles files
# install the packages
installDirectoryFiles files

consoleBreak
echo "External apps ready."
echo "Now, let's install apps from repos"
consoleBreak

# Confirm the setup!
while true; do
    read -p "Do you wish proceed with the massive setup from debian repos?" yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

# Install fix skype icons on top toolbar
# sudo apt-get install sni-qt sni-qt:i386

if dpkg-query -Wf'${db:Status-abbrev}' sni-qt 2>/dev/null | grep -q '^i'; then
    printf 'The package sni-qt is installed!\n' sni-qt
else
    sudo apt-get install sni-qt sni-qt:i386
fi

# Tell the user which apps will be installed beforehand
listRepositoryApps repoAppsList
# Install the apps
InstallRepositoryApps repoAppsList
# Autoremove any unnecessary packages
sudo apt-get autoremove

consoleBreak
echo "That's it, enjoy your ready working environment!"
consoleBreak