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
    # passwords for system
  vim ./config/envvars

    # populate sensitive information, /downloads
  ./prebuild.sh
  
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
    # passwords for system
  vim ./config/envvars

  # populate sensitive information, /downloads
  ./prebuild.sh
  
  # Run bash install (as root)
  ./bash_install.sh

  # Supply the appropriate password or prompts
    # Prompted to edit /etc/hosts file: enter VM_NAME from envvars on same line as IP
    # When installing Java, hit enter when prompted
  ```