#!/bin/bash
echo "---- Installing Supervisor ------------------------------------------------"

#### GET ENVARS #################################################
SHARED_DIR=$1

if [ -f "$SHARED_DIR/config/envvars" ]; then
  . $SHARED_DIR/config/envvars
  printf "Found your local envvars file. Using it."

else
  printf "Could not find envvars - remember to copy /config/envvars.* (e.g. envvars.public) to /config/envvars.  Aborting."
  exit 1
fi
#################################################################

# apt-get install 
apt-get -y install supervisor

# copy custom supervisor.conf file
cp $SHARED_DIR/config/ouroboros/supervisord.conf /etc/supervisor/

# chown supervisor directory for ouroboros
chown -R ouroboros:admin /etc/supervisor

# restart
service supervisor restart
