#!/bin/bash
echo "---- Cleanup ------------------------------------------------"

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

# copy apache / info file
cp $SHARED_DIR/config/cleanup/index.php /var/www/wsuls/

# turn on virtualenv
WORKON_HOME=/usr/local/lib/venvs
source /usr/local/bin/virtualenvwrapper.sh
workon ouroboros

# index all documents in Fedora to Solr, specifically to power front-end
# assumes Fedora, Solr, and Ouroboros are up and operational
curl --data "choice=confirm&confirm_string=confirm" "http://$VM_HOST:$OUROBOROS_PORT/tasks/updateSolr/purgeAndFullIndex"

deactivate

# Set Ouroboros permissions on ouroboros venv
chown -R ouroboros:admin /usr/local/lib/venvs/ouroboros

# Set Loris permissions on loris venv
chown -R loris:admin /usr/local/lib/venvs/loris

# Cleanup unneeded packages
sudo apt-get -y autoremove
