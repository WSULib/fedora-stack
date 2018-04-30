#!/bin/bash
echo "---- Installing Front-End Components ------------------------------------------------"

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

#################################################################
# Check build profile, skip if not needed
# comment out any profiles that DO need this provisioner, which will prevent skipping
if [ -z ${BUILD_PROFILE+x} ]; then 
	echo "BUILD_PROFILE environmental variable not found. Aborting.";
	exit 1; 
elif [ "$BUILD_PROFILE" == "dataslice" ]; then
  	echo "$BUILD_PROFILE does not require this provisioner, skipping..."
  	exit 0;
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

# Ensure PHP XML package for PHP7 is installed
apt-get -y install php7.0-xml


# pull in digital collections (mirador included)
cd /var/www/wsuls
git clone https://github.com/WSUlib/digitalcollections.git
cd digitalcollections
git checkout $FRONT_END_GIT_BUILD_BRANCH
chown -R ouroboros:admin /var/www/wsuls/digitalcollections
./provision.sh
cp $SHARED_DIR/downloads/front_end/digitalcollections/settings.php /var/www/wsuls/digitalcollections/src
touch /var/www/wsuls/digitalcollections/logs/app.log
chown www-data /var/www/wsuls/digitalcollections/logs/app.log
sed -i "s/VM_HOST/$VM_HOST/g" /var/www/wsuls/digitalcollections/src/settings.php

# pull in eTextReader
cd /var/www/wsuls
git clone https://github.com/WSUlib/eTextReader.git
chown -R www-data:www-data /var/www/wsuls/eTextReader
cd eTextReader
git checkout $FRONT_END_GIT_BUILD_BRANCH
# config
cp $SHARED_DIR/downloads/front_end/eTextReader/config.js /var/www/wsuls/eTextReader/config
cp $SHARED_DIR/downloads/front_end/eTextReader/config.php /var/www/wsuls/eTextReader/config
sed -i "s/VM_HOST/$VM_HOST/g" /var/www/wsuls/eTextReader/config/*
sed -i "s/FRONT_END_API_PREFIX/$FRONT_END_API_PREFIX/g" /var/www/wsuls/eTextReader/config/*
sed -i "s/FRONT_END_API_PREFIX/$FRONT_END_API_PREFIX/g" /var/www/wsuls/digitalcollections/src/settings.php
# sensitive
cp $SHARED_DIR/downloads/front_end/eTextReader/sensitive.php /var/www/wsuls/eTextReader/php
sed -i "s/FEDORA_ADMIN_USERNAME/$FEDORA_ADMIN_USERNAME/g" /var/www/wsuls/eTextReader/php/sensitive.php
sed -i "s/FEDORA_ADMIN_PASSWORD/$FEDORA_ADMIN_PASSWORD/g" /var/www/wsuls/eTextReader/php/sensitive.php
# create db for eTextReader table interface
mysql --user=root --password=$SQL_PASSWORD < $SHARED_DIR/downloads/front_end/eTextReader/image_capture.sql

# chown
chown -R www-data:admin /var/www/wsuls/eTextReader

# move to public directory
mv /var/www/wsuls/eTextReader /var/www/wsuls/digitalcollections/public

# set robots and google site verification
cd /var/www/wsuls
cp $SHARED_DIR/downloads/front_end/google288f165e0ae3f823.html /var/www/wsuls/
cp $SHARED_DIR/downloads/front_end/robots.txt /var/www/wsuls/
chown root:root robots.txt google288f165e0ae3f823.html
chmod 644 robots.txt google288f165e0ae3f823.html

