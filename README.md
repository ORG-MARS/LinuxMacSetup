# change root
- sudo -i
- passwd root

# prepare
- apt update -y && apt upgrade -y && apt install curl

# install 
- curl -L https://raw.githubusercontent.com/houko/LinuxMacSetup/ubuntu20/install.sh | sh
