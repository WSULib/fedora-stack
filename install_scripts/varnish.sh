#!/bin/bash
echo "--------------- Installing Varnish ------------------------------"

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

# install varnish
echo "apt-get for varnish"
apt-get -y install apt-transport-https
curl https://repo.varnish-cache.org/GPG-key.txt | apt-key add -
echo "deb https://repo.varnish-cache.org/ubuntu/ trusty varnish-4.1" >> /etc/apt/sources.list.d/varnish-cache.list
apt-get update
apt-get -y install varnish

# make cache dir
echo "creating varnish cache directory"
mkdir /var/cache/varnish

# copy config files from downloads
echo "copying varnish config files"
cp $SHARED_DIR/downloads/varnish/*.vcl /etc/varnish/
cp $SHARED_DIR/downloads/varnish/varnish /etc/default/
cp $SHARED_DIR/downloads/varnish/varnish_secret /home/ouroboros/
chown ouroboros:admin /home/ouroboros/varnish_secret

# restart varnish
service varnish restart

echo "varnish finis!"