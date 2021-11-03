# 先更新源清理老的安装包
apt update -y
apt upgrade -y
apt autoremove -y

# 关闭Swap
swapoff -a
sed 's/.*swap.*/#&/' /etc/fstab
swapoff -v /swap.img
# 删除交换分区文件
rm -rf /swap.img
free -m

# 关闭Selinux
apt install -y policycoreutils selinux-utils selinux-basics
selinux-config-enforcing
sestatus

systemctl enable kubelet
systemctl start kubelet
systemctl status kubelet