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

# Includes 3 line breaks in the command line
function consoleBreak {
    printf "\n\n\n"
}

# Gets information about a file extension
function getPackageExtension () {
    echo $1|awk -F . '{print $NF}'
}

# Creates a folder called "createArchivesFolder" on user's desktop
function createArchivesFolder {
    cd ~/Desktop/
    mkdir AppArchives
    cd AppArchives
    printf "\n"
    echo "A folder AppArchives has been created on your Desktop. Archive applications will be downloaded there."
    printf "\n"
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

# Lists the files in a given directory
# pass files array to list the files in a folder
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

#########################
# STARTING ACTUAL WORK #
########################

# clear the line
clear

echo "Startig the download and install of applications which are coming as archives and should be extracted"

# creating a folder called createArchivesFolder on the Desktop
createArchivesFolder

# downloading the archives
downloadArchives archiveApps

# get a list of files in the folder
files=(*)

# list the files
listDirectoryFiles files

# extracting the archives
ExtractFiles

sudo cp -r ~/Desktop/AppArchives/copy /opt/

consoleBreak
echo "You are done!"
