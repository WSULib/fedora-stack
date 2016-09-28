#!/bin/bash
echo "--------------- Installing Utilities ------------------------------"

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
# Set virtualenv variables and source file to work in current session
WORKON_HOME=/usr/local/lib/venvs
source /usr/local/bin/virtualenvwrapper.sh
# Create a global environment and a test environment
workon global

mkdir /opt/utilities

cd /opt/utilities
git clone https://github.com/WSULib/POTDemailer.git
git clone https://github.com/WSULib/SWORD2DC.git
git clone https://github.com/WSULib/digital-collections-sitemaps.git
git clone https://github.com/WSULib/dc2Solr.git


# Write cronjobs
# crontab -l | { cat; echo "0 * * * * some_entry"; } | crontab -
crontab -l | { cat; echo "# Downloads item records from DC, indexes in Solr"; } | crontab -
crontab -l | { cat; echo "#0 23    * * *      cd /opt/utilities/dc2Solr && /usr/local/lib/venvs/global/bin/python dc2Solr.py all >/dev/null 2>&1"; } | crontab -
crontab -l | { cat; echo "# Runs utility to harvest BioMed Central SWORD deposits in Fedora for ingest to Digital Commons"; } | crontab -
crontab -l | { cat; echo "#0 0    * * 1      /usr/local/lib/venvs/global/bin/python /opt/utilities/SWORD2DC/SWORD2DC.py >/dev/null 2>&1"; } | crontab -
crontab -l | { cat; echo "# Emails authors for DigitalCommons@WayneState's Paper of the Day"; } | crontab -
crontab -l | { cat; echo "#0 12    * * *      cd /opt/utilities/POTDemailer && /usr/local/lib/venvs/global/bin/python POTDemailer.py >/dev/null 2>&1"; } | crontab -
crontab -l | { cat; echo "# Runs script to update sitemaps for Google crawler"; } | crontab -
crontab -l | { cat; echo "#0 0    * * 0      cd /opt/utilities/digital-collections-sitemaps && /usr/local/lib/venvs/global/bin/python digital-collections-sitemaps.py >/dev/null 2>&1"; } | crontab -

# Install Dependencies
pip install pyPdf bs4 lxml mysolr requests

cp $SHARED_DIR/downloads/utilities/apesmit-0.01.tar.gz /tmp/
cd /tmp/
sudo tar -xvf /tmp/apesmit-0.01.tar.gz
cd /tmp/apesmit-0.01/
chown -R ouroboros:admin /tmp/apesmit-0.01/
python setup.py install

deactivate
