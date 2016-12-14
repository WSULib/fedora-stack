# gets global branch name to pull from and pulls

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

printf "\n\nChecking out branch: $BUILD_GLOBAL_GIT_BRANCH for fedora-stack-downloads\n\n"

git submodule update --init --recursive
git submodule foreach git pull origin $BUILD_GLOBAL_GIT_BRANCH
