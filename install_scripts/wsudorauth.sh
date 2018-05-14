#!/bin/bash
echo "---- Installing WSUDORauth ------------------------------------------------"

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

# Make virtualenv
WORKON_HOME=/usr/local/lib/venvs
source /usr/local/bin/virtualenvwrapper.sh
mkvirtualenv auth
workon auth

# create logging directory
mkdir /var/log/wsudorauth
chown -R ouroboros:admin /var/log/wsudorauth

# clone wsudorauth repository
cd /opt
git clone https://github.com/WSULib/wsudorauth.git
cd wsudorauth

# copy config and replace values
cp $SHARED_DIR/downloads/wsudorauth/localsettings.py /opt/wsudorauth/wsudorauth/localsettings.py
sed -i "s/VM_HOST/$VM_HOST/g" /opt/wsudorauth/wsudorauth/localsettings.py
sed -i "s/WSUDORAUTH_DB_USERNAME/$WSUDORAUTH_DB_USERNAME/g" /opt/wsudorauth/wsudorauth/localsettings.py
sed -i "s/WSUDORAUTH_DB_PASSWORD/$WSUDORAUTH_DB_PASSWORD/g" /opt/wsudorauth/wsudorauth/localsettings.py

# install pip dependencies
pip install -r requirements.txt

# create MySQL database, users, tables, then populate
cp $SHARED_DIR/downloads/wsudorauth/wsudorauth_mysql_db_create.sql /tmp
sed -i "s/WSUDORAUTH_DB_USERNAME/$WSUDORAUTH_DB_USERNAME/g" /tmp/wsudorauth_mysql_db_create.sql
sed -i "s/WSUDORAUTH_DB_PASSWORD/$WSUDORAUTH_DB_PASSWORD/g" /tmp/wsudorauth_mysql_db_create.sql
mysql --user=root --password=$SQL_PASSWORD < /tmp/wsudorauth_mysql_db_create.sql

# update db
python manage.py migrate

# create local account
echo "---CREATING local wsudorauth account---"
echo "from django.contrib.auth.models import User; User.objects.create_superuser('ouroboros', 'libwebmaster@wayne.edu', '$OUROBOROS_LOCAL_PASSWORD')" | python /opt/wsudorauth/manage.py shell

# collect static
python manage.py collectstatic --noinput

# chown
chown -R ouroboros:admin /opt/wsudorauth

# restart apache
sudo chown -R :admin /usr/local/lib/venvs/auth
service apache2 restart

# close
deactivate
echo "deactivating virtualenv"
