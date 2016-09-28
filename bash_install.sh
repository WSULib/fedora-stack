#!/bin/bash

#### CHECK USER #################################################
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
#################################################################

#### CHECK FOR ENVVARS #################################################
FILE=./config/envvars

if [ ! -f "$FILE" ]
then
    echo "$FILE does not exist. Please consult ./config/envvars.default to build it." 1>&2
    exit 1
fi
#################################################################

#### GET ENVARS #################################################
# set flag identifying that this is a non-vagrant install
NON_VAGRANT=true
# make a symbolic link from current directory to /vagrant
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
sudo ln -s $DIR /vagrant
set -- /vagrant
SHARED_DIR=$1

printf $SHARED_DIR
if [ -f "$SHARED_DIR/config/envvars" ]; then
  . $SHARED_DIR/config/envvars
  printf "found your local envvars file. Using it."

else
  . $SHARED_DIR/config/envvars.default
  printf "found your default envvars file. Using its default values."

fi
#################################################################

# Run provisioners
source $DIR/install_scripts/bootstrap.sh
source $DIR/install_scripts/lamp.sh
source $DIR/install_scripts/java.sh
source $DIR/install_scripts/tomcat.sh
source $DIR/install_scripts/varnish.sh
source $DIR/install_scripts/solr.sh
source $DIR/install_scripts/fedora.sh
source $DIR/install_scripts/oaiprovider.sh
source $DIR/install_scripts/supervisor.sh
source $DIR/install_scripts/kakadu.sh
source $DIR/install_scripts/rtail.sh
source $DIR/install_scripts/ouroboros.sh
source $DIR/install_scripts/front_end.sh
source $DIR/install_scripts/loris.sh
source $DIR/install_scripts/utilities.sh
source $DIR/install_scripts/cleanup.sh


# remove symlink
sudo unlink /vagrant

printf "DONE!"
