#!/bin/bash
# Start this script at newly installed Ubuntu 12.04 LTS
# The script will install all necessary software for setting up a web development environment
# The script is targeted for Ubuntu 12.04 LTS

###################################
# FUNCTIONS AND LIST DEFINITIONS #
##################################

# Declaring an array with list of external apps
declare -A archiveApps

archiveApps=(
    ["Copy"]="https://copy.com/install/linux/Copy.tgz"
)

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

# Includes 3 line breaks in the command line
function consoleBreak {
    printf "\n\n\n"
}

# Gets information about a file extension
function getPackageExtension () {
    echo $1|awk -F . '{print $NF}'
}

# Lists applications which are coming from external sources (not APT)
function listExternalApps () {
    printf "\n"
    echo "This is the list of external apps to be installed: "
    for i in "${!appsList[@]}"
    do
        echo "$i"
    done
    consoleBreak
}

# Lists applications which are coming from APT
function listRepositoryApps () {
    printf "\n"
    echo "This is the list of repository apps to be installed: "
    for i in "${!repoAppsList[@]}"
    do
        echo "$i"
    done
    consoleBreak
}

# Lists the files in a given directory
function listDirectoryFiles {
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

# Creates a folder called "ExternalApps" on user's desktop
function createExternalAppsFolder {
    cd ~/Desktop/
    mkdir ExternalApps
    cd ExternalApps
    printf "\n"
    echo "A folder ExternalApps has been created on your Desktop. Apps will be downloaded there."
    printf "\n"
}

# Creates a folder called "AppArchives" on user's desktop
function createArchivesFolder {
    cd ~/Desktop/
    mkdir AppArchives
    cd AppArchives
    printf "\n"
    echo "A folder AppArchives has been created on your Desktop. Archive applications will be downloaded there."
    printf "\n"
}

# Downloads applications which are external to APT
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

# Downloading archive applications which work with extraction only
# archiveApps array should be passed to the function to work 
function downloadArchives () {
    cd ~/Desktop/AppArchives
    echo "Starting the download of archives applications ..."
    for i in "${!archiveApps[@]}"
    do
        echo "Downloading $i ..."
        printf "\n"
        wget ${archiveApps[$i]}
    done
}

# Extracts and installs archive packages correspondingly
# Depends on function getPackageExtension in order to recognize the extension of a given package
function ExtractFiles () {
    files=(*)   
    for i in "${!files[@]}"
    do
        echo "Opening:"
        echo ${files[$i]}
        extension=$(getPackageExtension ${files[$i]})
        echo "This file is of extension:"
        echo $extension;
        if [ "$extension" = "tgz" ]; then
            tar -xvzf ${files[$i]}
        fi
    done
}

# Installs packages from a given directory. Recognizes .sh and .deb extensions
# Depends on function getPackageExtension in order to recognize the extension of a given package
function installDirectoryFiles {
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

# Installing applications through APT
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

############################
# STARTING THE ACTUAL WORK #
############################

# starting anew
clear

echo "The setup now begins."
echo "Installing the JDK7 package ..."

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

# Going to the newly created folder for external applications
cd ~/Desktop/ExternalApps

# list the files
listDirectoryFiles

# install the packages
installDirectoryFiles

echo "Downloading and installing applications which are archives ..."

# creating a folder called AppArchives on the Desktop
createArchivesFolder

# downloading the archives
downloadArchives archiveApps

# Going to the newly created folder for archive applications
cd ~/Desktop/AppArchives

# list the files
listDirectoryFiles

# extracting the archives
ExtractFiles

echo "Copying all extracted folders ot /opt/ folder ..."

# copying the /copy/ folder to /opt/
sudo cp -r ~/Desktop/AppArchives/* /opt/

consoleBreak
echo "External applications setup is ready."
echo "Now, let's install apps from APT."
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

if dpkg-query -Wf'${db:Status-abbrev}' sni-qt 2>/dev/null | grep -q '^i'; then
    printf 'The package sni-qt is installed!\n' sni-qt
else
    sudo apt-get install sni-qt sni-qt:i386
fi

# Tell the user which apps will be installed beforehand
listRepositoryApps repoAppsList

# Install the apps
InstallRepositoryApps repoAppsList

# Restart apache2 service if the application has been installed
sudo /etc/init.d/apache2 restart

# Should be the same, but just in case the first does not go through
sudo service apache2 restart

consoleBreak
echo "That's it, enjoy your ready working environment!"
consoleBreak