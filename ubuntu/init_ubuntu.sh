# 先更新源清理老的安装包
sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove -y

# 关闭Swap
swapoff -a
sudo sed 's/.*swap.*/#&/' /etc/fstab
sudo swapoff -v /swap.img
# 删除交换分区文件
sudo rm -rf /swap.img
free -m

# 关闭Selinux
sudo apt install -y policycoreutils selinux-utils selinux-basics
sudo selinux-config-enforcing
sestatus

sudo systemctl enable kubelet
sudo systemctl start kubelet
sudo systemctl status kubelet