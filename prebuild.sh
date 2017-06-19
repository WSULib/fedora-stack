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

# sed Vagrant file with information from envvars
cp Vagrantfile.template Vagrantfile
sed -i '.delete' "s/BUILD_PROFILE/$BUILD_PROFILE/g" Vagrantfile
sed -i '.delete' "s/VM_IP/$VM_IP/g" Vagrantfile
rm *.delete

printf "\n\nPrebuild complete!  Remember, please do not add/commit the newly created Vagrantfile (extensionless).\n\n"