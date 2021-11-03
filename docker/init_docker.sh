BASE_DIR="$HOME/.xiaomo"
curl -fsSL get.docker.com -o get-docker.sh
sh get-docker.sh
#sudo chmod 666 /var/run/docker.sock
sudo usermod -aG docker $USER

sudo cp $BASE_DIR/docker/daemon.json /etc/docker/daemon.json

sudo mkdir -p /etc/systemd/system/docker.service.d
sudo systemctl daemon-reload
sudo systemctl restart docker
docker info | grep "Cgroup Driver"

sudo systemctl start docker
sudo systemctl enable docker

# 测试
docker run hello-world
