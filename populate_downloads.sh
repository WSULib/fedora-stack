#!/bin/bash
echo "---- Populating sensitive /downloads folder ------------------------------------------------"

#### GET ENVARS #################################################
SHARED_DIR=$1

if [ -f "config/envvars" ]; then
  . config/envvars
  printf "found your local envvars file. Using it."

else
  . config/envvars.default
  printf "found your default envvars file. Using its default values."

fi
#################################################################

printf "\n\nChecking out branch: $DOWNLOADS_GIT_BUILD_BRANCH for fedora-stack-downloads\n\n"
git clone -b $DOWNLOADS_GIT_BUILD_BRANCH https://github.com/WSULib/fedora-stack-downloads.git downloads
