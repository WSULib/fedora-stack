#!/bin/bash
echo "---- Installing WSUDORauth ------------------------------------------------"

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

# Make virtualenv
WORKON_HOME=/usr/local/lib/venvs
source /usr/local/bin/virtualenvwrapper.sh
mkvirtualenv auth
workon auth

# clone readux repository
cd /opt
git clone https://github.com/WSULib/wsudorauth.git
cd wsudorauth

# copy config and replace values
cp $SHARED_DIR/downloads/wsudorauth/localsettings.py /opt/wsudorauth/wsudorauth/localsettings.py
sed -i "s/VM_HOST/$VM_HOST/g" /opt/wsudorauth/wsudorauth/localsettings.py
sed -i "s/WSUDORAUTH_DB_USERNAME/$WSUDORAUTH_DB_USERNAME/g" /opt/wsudorauth/wsudorauth/localsettings.py
sed -i "s/WSUDORAUTH_DB_PASSWORD/$WSUDORAUTH_DB_PASSWORD/g" /opt/wsudorauth/wsudorauth/localsettings.py
sed -i "s/WSUDORAUTH_DB_USERNAME/$WSUDORAUTH_DB_USERNAME/g" /opt/wsudorauth/wsudorauth/wsudorauth_mysql_db_create.sql
sed -i "s/WSUDORAUTH_DB_PASSWORD/$WSUDORAUTH_DB_PASSWORD/g" /opt/wsudorauth/wsudorauth/wsudorauth_mysql_db_create.sql

# install pip dependencies
pip install -r requirements.txt

# create MySQL database, users, tables, then populate
mysql --user=root --password=$SQL_PASSWORD < $SHARED_DIR/downloads/wsudorauth/wsudorauth_mysql_db_create.sql

# update db
python manage.py migrate

# chown
chown -R ouroboros:admin /opt/wsudorauth

# restart apache
sudo chown -R :admin /usr/local/lib/venvs/auth
service apache2 restart

# close
deactivate
echo "deactivating virtualenv"