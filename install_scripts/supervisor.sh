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

# apt-get install 
apt-get -y install supervisor

# copy custom supervisor.conf file
cp $SHARED_DIR/config/ouroboros/supervisord.conf /etc/supervisor/

# chown supervisor directory for ouroboros
chown -R ouroboros:admin /etc/supervisor

# restart
service supervisor restart
