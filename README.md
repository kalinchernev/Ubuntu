README
======

What is install.sh
----------------

install.sh prepares your Ubuntu 64 bit 12.04 LTS computer for web development with the Linux-Apache-MySQL-PHP.
Run the script and enjoy your ready working environment!

Features
--------

Ubuntu fixes
* Install the package to fix missing skype icon on toolbar

Server environment
* apache2
* PHP5
* mySQL
* phpmyadmin

Tools
* JDK7
* Netbeans
* git
* Google Chrome
* subversion (SVN)
* DropBox
* VirtualBox
* Skype
* Sublime Text 3

**Note:**
Note that some of the applications are downloaded via external sources (skype, Chrome, etc.), while others are directly installed via the Advanced Packaging Tool (APT).

External applications are downloaded on the Desktop, so that user can install them manually if necessary.

@Todo
------------
The following applications will also be included in the script
* VMWare Player
* nodeJS
* Drush
* XDebug

Other web development helpers are planned:
* Creating new web projects (folder, alias, database)
* Installing new Drupal project
* Building Drupal projects with continuous integration

Also, features-wise, there could be an automatic OS detection tool to work with different systems as well.

Installation
------------
Here are the steps you need to take to start the script:
* Download the WebDevSetup.sh file
* Open the terminal with 
	Ctrl+Atl+t
* Change to the folder where you have downloaded the file
* Add permissions to the file by 
	chmod +x ./WebDevSetup.sh
* Run by typing 
	./WebDevSetup.sh

Making it your own
------------
There are 2 lists of applications managed through the script - for repository apps, and external applications.
External applications are listed in the "appsList" array.
Applications installed via the APT are listed in the "repoAppsList" array.
You can change any of the sources to match your taste, i.e. include other editor, PHP version, etc.
