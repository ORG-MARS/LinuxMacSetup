# prepare
sudo apt update -y
sudo apt upgrade -y & sudo apt install curl

# bak
sudo rm /var/lib/dpkg/lock-frontend & sudo rm /var/lib/dpkg/lock & sudo rm /var/cache/apt/archives/lock

# install 
curl -L https://raw.githubusercontent.com/houko/macOrLinuxConfigSetup/ubuntu20/install.sh | sh