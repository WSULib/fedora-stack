#!/bin/bash
echo "---- Installing Loris (Image Server) ------------------------------------------------"

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

# turn on virtualenv
WORKON_HOME=/usr/local/lib/venvs
source /usr/local/bin/virtualenvwrapper.sh

mkvirtualenv loris
workon loris
# dependencies
sudo apt-get -y install python-setuptools

printf "\n" | sudo pip uninstall PIL
printf "y \n" | sudo pip uninstall Pillow
sudo apt-get -y purge python-imaging

sudo apt-get -y install libjpeg-turbo8-dev libfreetype6-dev zlib1g-dev \
liblcms2-dev liblcms-utils libtiff5-dev python-dev libwebp-dev apache2 \
libapache2-mod-wsgi

printf "\n" | sudo pip install Pillow

# clone repo and install
cd /var/lib
git clone https://github.com/WSULib/loris.git

# install
echo "installing Loris"
cd loris
# set upstream
git remote add upstream https://github.com/loris-imageserver/loris
python setup.py install --verbose --config-dir=/etc/loris2 --log-dir=/var/log/loris2 --www-dir=/opt/loris2 --kdu-expand=/usr/local/bin/kdu_expand --libkdu=/usr/local/lib  --info-cache=/var/cache/loris2 --image-cache=/var/cache/loris2

# copy custom config file, and udpate host info for proxy
echo "copying conf file"
cp $SHARED_DIR/downloads/loris/loris2.conf /etc/loris2/
sed -i "s/HOST_PLACEHOLDER/$VM_HOST/g" /etc/loris2/loris2.conf

# copy custom wsgi file into www
cp $SHARED_DIR/downloads/loris/loris2.wsgi /opt/loris2/loris2.wsgi
chown loris:admin /opt/loris2/loris2.wsgi
chmod 755 /opt/loris2/loris2.wsgi

# change ownership
chown -R loris:admin /var/log/loris2

# stop virtualenv -- this should hopefully then indicate if apache is succesfully loading the loris
# virtualenv on itself
sudo chown -R loris:admin /usr/local/lib/venvs/loris
deactivate

# cache management script as cron job
# Uses custom cache cleaning script with hardcoded directories and 5gb limit
cp $SHARED_DIR/downloads/loris/loris-http_cache_clean.sh /var/lib/loris/bin/loris-http_cache_clean.sh
printf "setting cache clean cronjob"
sudo -u loris -H sh -c '(crontab -l 2>/dev/null; echo "*/1 * * * * /var/lib/loris/bin/loris-http_cache_clean.sh") | crontab -'

# chown dirs
chown -R loris:admin /var/lib/loris
chmod 755 /var/lib/loris
chown -R loris:admin /var/cache/loris2
chmod 755 /var/cache/loris2

# restart apache2
echo "restarting apache"
service apache2 restart

# check install
curl localhost/loris



