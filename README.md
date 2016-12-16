# fedora-stack
fedora-stack-prod

## Installing via vagrant
  ```
  # clone repository
  git clone https://github.com/WSULib/fedora-stack.git
  cd fedora-stack

  # create local configuration file from template
  mv ./config/envvars.default ./config/envvars

  # edit configuration
    # set host
    # VM name
    # check or set git branch to checkout for a some downstream components (e.g. /dowloads directory, Ouroboros, front-end, etc.)
    # passwords for system
  vim ./config/envvars
  
  # finally, fire up VM
  vagrant up
  ```

## Installing via bash script
  ```
  # clone repository
  git clone https://github.com/WSULib/fedora-stack.git
  cd fedora-stack

  # create local configuration file from template
  mv ./config/envvars.default ./config/envvars

  # edit configuration
    # set host
    # VM name
    # check or set git branch to checkout for a some downstream components (e.g. /dowloads directory, Ouroboros, front-end, etc.)
    # passwords for system
  vim ./config/envvars
  
  # Run bash install (as root)
  ./bash_install.sh

  # Supply the appropriate password or prompts
    # Prompted to edit /etc/hosts file: enter VM_NAME from envvars on same line as IP
    # When installing Java, hit enter when prompted
  ```
