#!/bin/bash
echo "--------------- Installing Solr 4.1 ------------------------------"

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

printf "Acquiring and Installing Solr"
if [ -f $SHARED_DIR/downloads/solr/solr-$SOLR_VERSION.tgz ]; then
	echo "Solr file exists, skipping download..."
else
	echo "Solr file does not exist, downloading..."
	wget -P $SHARED_DIR/downloads/solr/ "http://archive.apache.org/dist/lucene/solr/$SOLR_VERSION/solr-$SOLR_VERSION.tgz"
fi
cd /tmp
cp $SHARED_DIR/downloads/solr/solr-$SOLR_VERSION.tgz /tmp
echo "Extracting Solr"
tar -xzf solr-"$SOLR_VERSION".tgz
cp -v /tmp/solr-"$SOLR_VERSION"/dist/solr-"$SOLR_VERSION".war /var/lib/tomcat7/webapps/solr4.war
service tomcat7 restart

# Waiting for Solr war file to initialize and create the solr4 directory
while [ ! -d /var/lib/tomcat7/webapps/solr4/WEB-INF/ ]
do
 echo "waiting for Solr to deploy..."
 sleep 2
done

echo "deployed. finishing installation..."

service tomcat7 stop

chown -hR tomcat7:tomcat7 /usr/share/tomcat7/lib

cp $SHARED_DIR/downloads/solr/$SOLR_CATALINA_CONFIG /etc/tomcat7/Catalina/localhost/solr4.xml

chown -hR tomcat7:tomcat7 /etc/tomcat7/Catalina/localhost

# copying pre-initialized solr cores and libraries
echo "copying solr cores"
cp -r $SHARED_DIR/downloads/solr/multicore $SOLR_HOME/
cp -r $SHARED_DIR/downloads/solr/lib $SOLR_HOME/

# make custom search component for fedobjs
git clone https://github.com/WSULib/ItemMatch.git /tmp/ItemMatch
JAVA_HOME=/usr/lib/jvm/java-8-oracle/
mvn install -f /tmp/ItemMatch/
cp /tmp/ItemMatch/target/*.jar $SOLR_HOME/lib/ItemMatch.jar
chmod 755 $SOLR_HOME/lib/ItemMatch.jar
rm -r /tmp/ItemMatch


chown -hR tomcat7:tomcat7 $SOLR_HOME

service tomcat7 start
