#!/bin/bash
echo "---- Installing Front-End Components ------------------------------------------------"

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

# install pear, php-dev, and solr depencdencies for front-end
apt-get -y install php5-dev php-pear libcurl4-gnutls-dev libpcre3-dev
printf "\n" | pecl install -n solr
echo "extension=solr.so" >> /etc/php/7.0/apache2/php.ini
echo "extension=solr.so" > /etc/php/7.0/apache2/conf.d/solr.ini
echo "extension=solr.so" > /etc/php/7.0/cli/conf.d/solr.ini
service apache2 restart

# pull in digital collections (mirador included)
cd /var/www/wsuls
git clone https://github.com/WSUlib/digitalcollections.git
cd digitalcollections
git checkout $FRONT_END_GIT_BUILD_BRANCH
./provision.sh
cp $SHARED_DIR/downloads/front_end/digitalcollections/settings.php /var/www/wsuls/digitalcollections/src
chown -R ouroboros:admin ~/.composer
chown -R ouroboros:admin /var/www/wsuls/digitalcollections
touch /var/www/wsuls/digitalcollections/logs/app.log
chown www-data /var/www/wsuls/digitalcollections/logs/app.log

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
sed -i "s/VM_HOST/$VM_HOST/g" /var/www/wsuls/digitalcollections/src/settings.php
sed -i "s/FRONT_END_API_PREFIX/$FRONT_END_API_PREFIX/g" /var/www/wsuls/digitalcollections/src/settings.php
# sensitive
cp $SHARED_DIR/downloads/front_end/eTextReader/sensitive.php /var/www/wsuls/eTextReader/php
sed -i "s/FEDORA_ADMIN_USERNAME/$FEDORA_ADMIN_USERNAME/g" /var/www/wsuls/eTextReader/php/sensitive.php
sed -i "s/FEDORA_ADMIN_PASSWORD/$FEDORA_ADMIN_PASSWORD/g" /var/www/wsuls/eTextReader/php/sensitive.php

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

