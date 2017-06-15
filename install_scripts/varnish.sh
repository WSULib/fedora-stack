#!/bin/bash
echo "--------------- Installing Varnish ------------------------------"

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

#################################################################
# Check build profile, skip if not needed
# comment out any profiles that DO need this provisioner, which will prevent skipping
if [ -z ${BUILD_PROFILE+x} ]; then 
	echo "BUILD_PROFILE environmental variable not found. Aborting.";
	exit 1; 
# elif [ "$BUILD_PROFILE" == "dataslice" ]; then
#   	echo "$BUILD_PROFILE does not require this provisioner, skipping..."
#   	exit 0;
# elif [ "$BUILD_PROFILE" == "workdev" ]; then
#   	echo "$BUILD_PROFILE does not require this provisioner, skipping..."
#   	exit 0;
# elif [ "$BUILD_PROFILE" == "public" ]; then
#   	echo "$BUILD_PROFILE does not require this provisioner, skipping..."
#   	exit 0;
# elif [ "$BUILD_PROFILE" == "local" ]; then
#   	echo "$BUILD_PROFILE does not require this provisioner, skipping..."
#   	exit 0;
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
chown ouroboros:admin /etc/varnish/secret

# set up configuration. Varnish does not seem to read /etc/default/varnish in Ubuntu 16.04
sed -i "s/ExecStart=.*/ExecStart=\/usr\/sbin\/varnishd \-j unix,user=vcache \-F \-a \:6081 \-T localhost\:6082 \-f \/etc\/varnish\/default.vcl \-S \/etc\/varnish\/secret \-s file,\/var\/cache\/varnish\/,2g/" /lib/systemd/system/varnish.service

# Load new configuration in systemd
systemctl daemon-reload

# restart varnish
systemctl restart varnish.service

echo "varnish finis!"
