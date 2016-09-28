#!/bin/bash
echo "---- Log Monitor ------------------------------------------------"

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

# Install Node and Node Package Manager
sudo apt-get -y install nodejs npm

# Make a symlink because Ubuntu calls node nodejs, which is confusing for all instructions you'll find online
sudo ln -s /usr/bin/nodejs /usr/bin/node

# Install rtail
sudo npm install -g rtail

# copy rtail conf to supervisor dir, reread, update (automatically starts then)
cp $SHARED_DIR/config/rtail/rtail-server.conf /etc/supervisor/conf.d/
cp $SHARED_DIR/config/rtail/rtail-celery-celery.conf /etc/supervisor/conf.d/
cp $SHARED_DIR/config/rtail/ouroboros-err.conf /etc/supervisor/conf.d/

supervisorctl reread
supervisorctl update
