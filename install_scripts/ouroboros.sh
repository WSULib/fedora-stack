#!/bin/bash
echo "---- Installing Ouroboros ------------------------------------------------"

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

if [ ! -d $OUROBOROS_HOME ]; then
  mkdir $OUROBOROS_HOME
fi

# Make virtualenv
WORKON_HOME=/usr/local/lib/venvs
source /usr/local/bin/virtualenvwrapper.sh
mkvirtualenv ouroboros
workon ouroboros

# clone Ouroboros repository
cd /opt
git clone https://github.com/WSULib/ouroboros.git
cd ouroboros
git checkout $OUROBOROS_GIT_BUILD_BRANCH

# fire ouroboros_assets
git submodule update --init --recursive

# copy php script for supporting Datatables
cp $SHARED_DIR/downloads/ouroboros/*.php /usr/lib/cgi-bin
chown -R www-data:www-data /usr/lib/cgi-bin

# install system dependencies
apt-get -y install libxml2-dev libxslt1-dev python-dev libldap2-dev libsasl2-dev libjpeg-dev pdftk imagemagick libreoffice-common xpdf
apt-get -y install libmysqlclient-dev

# for python virtualenv
pip install MySQL-python lxml

# python modules
pip install -r requirements.txt

# other applications
# redis
apt-get -y install redis-server

# copy ouroboros's localConfig and replace host info
cp $SHARED_DIR/downloads/ouroboros/localConfig.py /opt/ouroboros/localConfig.py
sed -i "s/APP_HOST_PLACEHOLDER/$VM_HOST/g" /opt/ouroboros/localConfig.py
sed -i "s/OUROBOROS_API_PREFIX/$OUROBOROS_API_PREFIX/g" /opt/ouroboros/localConfig.py
sed -i "s/OUROBOROS_FEDCONSUMER_FIRE/$OUROBOROS_FEDCONSUMER_FIRE/g" /opt/ouroboros/localConfig.py
sed -i "s/OUROBOROS_REPOSITORY_NAME/$OUROBOROS_REPOSITORY_NAME/g" /opt/ouroboros/localConfig.py

cd /opt

# install WSULib fork of piffle
pip install git+https://github.com/WSULib/piffle@develop

# install eulfedora from 1.7.2 release
wget https://github.com/emory-libraries/eulfedora/archive/1.7.2.zip
unzip /opt/1.7.2.zip
rm /opt/1.7.2.zip
mv /opt/eulfedora-1.7.2 /opt/eulfedora
chown -R ouroboros:admin /opt/eulfedora
cd eulfedora
workon ouroboros
python setup.py install
pip install -e .
chown -R ouroboros:admin /opt/eulfedora

# install artecfactual mets-reader-writer library (metsrw)
cd /opt
git clone https://github.com/WSULib/mets-reader-writer.git
chown -R ouroboros:admin /opt/mets-reader-writer
cd mets-reader-writer
workon ouroboros
python setup.py install

# install jpylyzer from openpreserve
cd /opt
git clone https://github.com/WSULib/jpylyzer.git
chown -R ouroboros:admin /opt/jpylyzer
cd jpylyzer
workon ouroboros
python setup.py install

# install WSU fork of pypremis
cd /opt
git clone https://github.com/WSULib/uchicagoldr-premiswork pypremis
cd pypremis
git checkout wsudor
chown -R ouroboros:admin /opt/pypremis
workon ouroboros
python setup.py install

# Finish Ouroboros configuration
cd /opt/ouroboros
# create MySQL database, users, tables, then populate
mysql --user=root --password=$SQL_PASSWORD < $SHARED_DIR/downloads/ouroboros/ouroboros_mysql_db_create.sql
echo "creating MySQL database, users, and tables"
ipython <<EOF
from console import *
tableWipe()
EOF

# scaffold
chown -R ouroboros:admin /opt/ouroboros

mkdir /tmp/Ouroboros
mkdir /tmp/Ouroboros/ingest_workspace
mkdir /tmp/Ouroboros/ingest_jobs
chown -R ouroboros:admin /tmp/Ouroboros/

mkdir /var/www/wsuls/Ouroboros
mkdir /var/www/wsuls/Ouroboros/export/
chown -R ouroboros:admin /var/www/wsuls/Ouroboros

# fedora_binary symlinks
mkdir /var/cache/ouroboros
mkdir /var/cache/ouroboros/fedora_binary_symlinks
chown -R ouroboros:admin /var/cache/ouroboros/fedora_binary_symlinks

# LMDB location
mkdir /var/cache/lmdb
chown -R ouroboros:admin /var/cache/lmdb

# create for first run
mkdir /var/run/ouroboros
chown -R ouroboros:admin /var/run/ouroboros
# setup /etc/tmpfiles.d file for ouroboros on reboot
echo "d /var/run/ouroboros 0775 ouroboros admin" > /etc/tmpfiles.d/ouroboros.conf

# copy rc.local
cp $SHARED_DIR/downloads/ouroboros/rc.local /etc

# copy Ouroboros and Celery conf to supervisor dir, reread, update (automatically starts then)
cp $SHARED_DIR/config/ouroboros/ouroboros.conf /etc/supervisor/conf.d/
supervisorctl reread
supervisorctl update

# install Jupyter notebook server
pip install jupyter
# copy supervisor and config files
mkdir /home/ouroboros/.jupyter
cp $SHARED_DIR/downloads/ouroboros/jupyter_notebook_config.py /home/ouroboros/.jupyter
chown -R ouroboros:admin /home/ouroboros/.jupyter
cp $SHARED_DIR/downloads/ouroboros/ouroboros_jupyter.conf /etc/supervisor/conf.d
sed -i "s/VM_HOST/$VM_HOST/g" /etc/supervisor/conf.d/ouroboros_jupyter.conf
supervisorctl reread
supervisorctl update

######### Extra Dependencies ##########################
# dependencies for pillow
sudo apt-get -y install libtiff5-dev libjpeg8-dev zlib1g-dev libfreetype6-dev liblcms2-dev libwebp-dev tcl8.6-dev tk8.6-dev python-tk
# reinstall pillow
printf "y \n" | pip uninstall pillow
pip install --no-cache-dir pillow

# stop virtualenv
sudo chown -R :admin /usr/local/lib/venvs/ouroboros
deactivate
echo "deactivating virtualenv"

# set cron job for autoindexing
printf "setting autoindexing cron job: $OUROBOROS_SCHEDULED_INDEXING"
sudo -u ouroboros -H sh -c '(crontab -l 2>/dev/null; echo "$OUROBOROS_SCHEDULED_INDEXING") | crontab -'




