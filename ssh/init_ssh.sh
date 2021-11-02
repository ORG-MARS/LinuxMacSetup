sudo apt install net-tools -y
sudo apt install openssh-server -y
sudo systemctl status ssh
sudo ufw allow ssh

# 创建ssh密钥
ssh-keygen -q -N " " -f ~/.ssh/id_rsa
chmod 700 ~/.ssh
chmod 600 authorized_keys
cat ~/.ssh/id_rsa.pub >> authorized_keys
