#!/bin/bash
echo "---- Installing Supervisor ------------------------------------------------"

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

# Update repository listing.
echo "deb http://us.archive.ubuntu.com/ubuntu/ xenial-proposed restricted main multiverse universe" >> /etc/apt/sources.list

# Let's not let the proposed packages be available except if we ask for them explicitly (like below)
touch /etc/apt/preferences.d/proposed-updates
echo $'Package: *\nPin: release a=xenial-proposed\nPin-Priority: 400' >> /etc/apt/preferences.d/proposed-updates
apt-get -y update

# apt-get install 
apt-get -y install supervisor/xenial-proposed

# copy custom supervisor.conf file
cp $SHARED_DIR/config/ouroboros/supervisord.conf /etc/supervisor/

# chown supervisor directory for ouroboros
chown -R ouroboros:admin /etc/supervisor

# restart
service supervisor restart
