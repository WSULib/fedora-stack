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

# clone downloads directory 
printf "\n\nChecking out branch: $DOWNLOADS_GIT_BUILD_BRANCH for fedora-stack-downloads\n\n"
git clone https://github.com/WSULib/fedora-stack-downloads.git downloads
cd downloads
git checkout tags/v1.0

# message to user
printf "\n\nRemember to set your envvars file (copy envvars.default to envvars), noting which branch to checkout for Ouroboros and Front-End\n\n"