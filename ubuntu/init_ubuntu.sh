# 先更新源清理老的安装包
sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove -y

# 关闭Swap
swapoff -a
sed 's/.*swap.*/#&/' /etc/fstab
free -m

# 关闭Selinux
sudo apt install -y policycoreutils selinux-utils selinux-basics
sudo selinux-config-enforcing
sestatus