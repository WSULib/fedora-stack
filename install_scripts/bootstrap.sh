#!/bin/bash
echo "---- Bootstrapping ------------------------------------------------"

#### GET ENVARS #################################################
SHARED_DIR=$1

if [ -f "$SHARED_DIR/config/envvars" ]; then
  . $SHARED_DIR/config/envvars
  printf "found your local envvars file. Using it."

else
  . $SHARED_DIR/config/envvars.default
  printf "found your default envvars file. Using its default values."

fi
#################################################################

# Update
apt-get -y update && apt-get -y upgrade

# SSH
apt-get -y install openssh-server

# create admin group
groupadd admin

# Build tools
apt-get -y install build-essential

# Python essentials
apt-get -y install libxml2-dev libxslt1-dev python-dev python-setuptools

# Install pip
sudo easy_install pip

# Install zlib
sudo apt-get -y install zlib1g-dev

# Remove python-six in order to allow pip to install the most up-to-date version of six
sudo apt-get -y purge python-six

# Install virtualenv and wrappers
pip install virtualenv virtualenvwrapper
mkdir /usr/local/lib/venvs
sudo chown :admin /usr/local/lib/venvs
echo "WORKON_HOME=/usr/local/lib/venvs" >> /etc/environment
echo "# Added for virtualenvwrapper" >> /etc/bash.bashrc
echo "source /usr/local/bin/virtualenvwrapper.sh" >> /etc/bash.bashrc

# Set virtualenv variables and source file to work in current session
WORKON_HOME=/usr/local/lib/venvs
source /usr/local/bin/virtualenvwrapper.sh
# Create a global environment and a test environment
mkvirtualenv global

# Install ipython on global
workon global
pip install ipython
deactivate

mkvirtualenv develop
sudo chown -R :admin /usr/local/lib/venvs

# Git vim
apt-get -y install git vim

# Wget and curl
apt-get -y install wget curl

# FFmpeg
sudo add-apt-repository -y ppa:mc3man/trusty-media
sudo apt-get -y update
sudo apt-get -y install ffmpeg

# visualization tools
apt-get -y install htop tree ncdu

# setup tailing
apt-get -y install multitail
echo "multitail /var/log/apache2/$VM_NAME-access.log /var/log/apache2/$VM_NAME-error.log /var/log/tomcat7/catalina.out /var/log/ouroboros.err.log /var/log/celery.err.log /opt/fedora/server/logs/fedora.log" > /usr/bin/alltails
chmod +x /usr/bin/alltails

# UPDATE NETWORKING ON NON-VAGRANT INSTALLS
#########################################################
if [ -z ${NON_VAGRANT+x} ]; then 
  echo "not editing /etc/hosts as this is a vagrant install";
else
  vim /etc/hosts;
fi


# CREATE USERS
#########################################################

#admin-ify vagrant
usermod -a -G admin vagrant

# Create loris user
useradd -m -s /bin/bash loris
echo loris:password | chpasswd

# Create ouroboros user
useradd -m -s /bin/bash ouroboros
usermod -g admin ouroboros
echo ouroboros:ouroboros | chpasswd
