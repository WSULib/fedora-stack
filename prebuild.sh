#!/bin/bash
echo "---- Populating sensitive /downloads folder ------------------------------------------------"

#### GET ENVARS #################################################
SHARED_DIR=$1

if [ -f "config/envvars" ]; then
  . config/envvars
  printf "found your local envvars file. Using it."
else
  printf "Could not find envvars - remember to copy /config/envvars.* (e.g. envvars.public) to /config/envvars.  Aborting."
  exit 1
fi
#################################################################

# clone downloads directory 
printf "\n\nChecking out branch: $DOWNLOADS_GIT_BUILD_BRANCH for fedora-stack-downloads\n\n"
git clone -b $DOWNLOADS_GIT_BUILD_BRANCH https://github.com/WSULib/fedora-stack-downloads.git downloads

# message to user
printf "\n\nRemember to set your envvars file (copy envvars.default to envvars), noting which branch to checkout for Ouroboros and Front-End\n\n"