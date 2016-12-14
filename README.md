# fedora-stack-prod
fedora-stack-prod

#### Installing via vagrant
  ```
  # clone repository
  git clone https://github.com/WSULib/fedora-stack-prod.git
  cd fedora-stack

  # create local configuration file
  mv ./config/envvars.default ./config/envvars

  # edit configuration file with IP, passwords, global git branch for each system component, etc.
  vim ./config/envvars
  
  # populate downloads directory from `fedora-stack-downloads` repository
  ./populate_downloads.sh

  # confirm that `/downloads` is populated

  vagrant up
  ```

#### Installing via bash script
  ```
  sudo apt-get update
  (if needed) sudo apt-get -y install git
  git clone https://github.com/WSULib/fedora-stack-prod.git
  cd fedora-stack
  Create config/envvars file from config/envvars.default (fill in necessary values)
  ./populate_downloads.sh
  Running as root, run ./bash_install.sh
  Supply the appropriate password when prompted
  Prompted to edit /etc/hosts file: enter VM_NAME from envvars on same line as IP
  When installing Java, hit enter when prompted
  ```
