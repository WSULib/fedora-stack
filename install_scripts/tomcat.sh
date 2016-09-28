#!/bin/bash
echo "---- Installing Tomcat ------------------------------------------------"

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

# Tomcat
apt-get -y install tomcat7 tomcat7-admin
usermod -a -G tomcat7 vagrant

if ! grep -q "role rolename=\"fedoraAdmin\"" /etc/tomcat7/tomcat-users.xml ; then
  sed -i '$i<role rolename="fedoraUser"/>
  $i<role rolename="fedoraAdmin"/>
  $i<role rolename="manager-gui"/>
  $i<user username="testuser" password="testuser" roles="fedoraUser"/>  
  $i<user username="fedoraAdmin" password="fedoraAdmin" roles="fedoraAdmin"/>
  $i<user username="tomcat" password="tomcat" roles="manager-gui,manager-script"/>' /etc/tomcat7/tomcat-users.xml
fi

if ! grep -q "/usr/lib/jvm/java-8-oracle" /etc/default/tomcat7 ; then
  echo "JAVA_HOME=/usr/lib/jvm/java-8-oracle" >> /etc/default/tomcat7
fi

# Make the ingest directory
mkdir /mnt/ingest
chown -R tomcat7:tomcat7 /mnt/ingest

# Edit tomcat configuration to allow Reverse proxying with Java containers
perl -i -0777 -pe 's/\s*<!--\s*\n(.*?port="8009".*?)\n\s*-->/\n$1/' /etc/tomcat7/server.xml


# Up max and perm size memory allocated to Tomcat
touch /usr/share/tomcat7/bin/setenv.sh
{ echo "JAVA_OPTS='$JAVA_OPTS -server -XX:+UseParallelGC -Xms1g -Xmx1g -XX:+DisableExplicitGC -XX:SurvivorRatio=10 -XX:TargetSurvivorRatio=90 -verbose:gc -Xloggc:/var/log/tomcat7/ggc.log -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+PrintHeapAtGC'"; echo "export JAVA_OPTS"; } >> /usr/share/tomcat7/bin/setenv.sh
chmod +x /usr/share/tomcat7/bin/setenv.sh

# restart tomcat
service tomcat7 restart

