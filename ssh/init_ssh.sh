apt install net-tools -y
apt install openssh-server -y
systemctl status ssh
ufw allow ssh

# 创建ssh密钥 密码是一个空格
ssh-keygen -q -N " " -f ~/.ssh/id_rsa
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
cat ~/.ssh/id_rsa.pub >>authorized_keys
cat ~/.ssh/authorized_keys