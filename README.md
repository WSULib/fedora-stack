# fedora-stack-prod
fedora-stack-prod

#### Installing via vagrant
  ```
  git clone https://github.com/WSULib/fedora-stack-prod.git
  cd fedora-stack-prod
  unzip downloads.zip
  vagrant up
  ```

#### Installing via bash script
  ```
  sudo apt-get update
  (if needed) sudo apt-get -y install git
  git clone https://github.com/WSULib/fedora-stack-prod.git
  cd fedora-stack-prod
  unzip downloads.zip
  Create config/envvars file from config/envvars.default (fill in necessary values)
  Running as root, run ./bash_install.sh
  Supply the appropriate password when prompted
  Prompted to edit /etc/hosts file: enter VM_NAME from envvars on same line as IP
  When installing Java, hit enter when prompted
  ```
