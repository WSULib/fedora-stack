#!/bin/bash
echo "---- Installing Kakadu JP2 Codec ------------------------------------------------"

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
