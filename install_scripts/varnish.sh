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
apt-get update
apt-get -y install varnish

# make cache dir
echo "creating varnish cache directory"
mkdir /var/cache/varnish

# copy config files from downloads
echo "copying varnish config files"
cp $SHARED_DIR/downloads/varnish/*.vcl /etc/varnish/
cp $SHARED_DIR/downloads/varnish/varnish /etc/default/
cp $SHARED_DIR/downloads/varnish/varnish_secret /etc/varnish/secret

# set up configuration. Varnish does not seem to read /etc/default/varnish in Ubuntu 16.04
sed -i "s/ExecStart=.*/ExecStart=\/usr\/sbin\/varnishd \-j unix,user=vcache \-F \-a \:6081 \-T localhost\:6082 \-f \/etc\/varnish\/default.vcl \-S \/etc\/varnish\/secret \-s file,\/var\/cache\/varnish\/,2g/" /lib/systemd/system/varnish.service

# Load new configuration in systemd
systemctl daemon-reload

# restart varnish
systemctl restart varnish.service

echo "varnish finis!"
