#!/bin/bash
echo "---- Installing OAIProvider for Fedora Commons ------------------------------------------------"

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

# create MySQL database, users, tables, then populate ('proai' hardcoded below as db name)
echo "creating MySQL database, users, and tables"
mysql --user=root --password=$SQL_PASSWORD < $SHARED_DIR/downloads/oaiprovider/oaiprovider_mysql_db_create.sql
mysql --user=root --password=$SQL_PASSWORD proai < $SHARED_DIR/config/oaiprovider/oaiprovider_tables_create.sql

# download in download dir from here: http://www.fedora-commons.org/software/repository
# documentation: https://wiki.duraspace.org/display/FCSVCS/OAI+Provider+Configuration+Reference

# unzip to tmp, move to Tomcat
echo "unzipping and moving war file"
unzip $SHARED_DIR/downloads/oaiprovider/oaiprovider-1.2.zip -d /tmp
cp /tmp/oaiprovider-1.2/oaiprovider.war /var/lib/tomcat7/webapps/

# restart Tomcat
service tomcat7 restart

# wait for Tomcat deployment
while [ ! -d /var/lib/tomcat7/webapps/oaiprovider/WEB-INF/classes ]
do
  echo "waiting for Tomcat to deploy..."
  sleep 2
done

# move config file to Tomcat
echo "copying config template and replacing values"
cp $SHARED_DIR/downloads/oaiprovider/proai.properties /var/lib/tomcat7/webapps/oaiprovider/WEB-INF/classes
sed -i "s/FEDORA_ADMIN_USERNAME/$FEDORA_ADMIN_USERNAME/g" /var/lib/tomcat7/webapps/oaiprovider/WEB-INF/classes/proai.properties
sed -i "s/FEDORA_ADMIN_PASSWORD/$FEDORA_ADMIN_PASSWORD/g" /var/lib/tomcat7/webapps/oaiprovider/WEB-INF/classes/proai.properties
sed -i "s/proai.db.url = jdbc:postgresql:\/\/localhost\/proai/proai.db.url = jdbc:mysql:\/\/localhost\/proai?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true/g" /var/lib/tomcat7/webapps/oaiprovider/WEB-INF/classes/proai.properties

# restart Tomcat
service tomcat7 restart
