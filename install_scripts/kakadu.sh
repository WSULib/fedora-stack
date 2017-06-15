#!/bin/bash
echo "---- Installing Kakadu JP2 Codec ------------------------------------------------"

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

# retrieved from here: http://kakadusoftware.com/downloads/

# dependencies
apt-get -y install exiv2

# copy and unzip
echo "copying and unzipping..."
cp $SHARED_DIR/downloads/kakadu/KDU77_Demo_Apps_for_Linux-x86-64_150710.zip /tmp
cd /tmp
unzip KDU77_Demo_Apps_for_Linux-x86-64_150710.zip
cd KDU77_Demo_Apps_for_Linux-x86-64_150710

# dispersing files
echo "dispersing files..."
cp kdu* /usr/local/bin
cp *.so /usr/lib
