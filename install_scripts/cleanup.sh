#!/bin/bash
echo "---- Cleanup ------------------------------------------------"

#### GET ENVARS #################################################
SHARED_DIR=$1

if [ -f "$SHARED_DIR/config/envvars" ]; then
  . $SHARED_DIR/config/envvars
  printf "Found your local envvars file. Using it."

else
  . $SHARED_DIR/config/envvars.default
  printf "Could not find envvars - remember to copy /config/envvars.* (e.g. envvars.public) to /config/envvars.  Aborting."
  exit 1
fi
#################################################################

# Set Ouroboros permissions on ouroboros venv
chown -R ouroboros:admin /usr/local/lib/venvs/ouroboros

# Set Loris permissions on loris venv
chown -R loris:admin /usr/local/lib/venvs/loris

# Cleanup unneeded packages
sudo apt-get -y autoremove
