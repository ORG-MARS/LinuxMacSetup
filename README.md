# prepare
sudo apt update -y && sudo apt upgrade -y && sudo apt install curl

# install 
curl -L https://raw.githubusercontent.com/houko/macOrLinuxConfigSetup/ubuntu20/install.sh | sh

# kubeadm
在master上用ip a可以查看内网地址，配在--apiserver-advertise-address上   

```sh
kubeadm init \
--apiserver-advertise-address=192.168.2.136 \
--kubernetes-version $(curl -L -s https://dl.k8s.io/release/stable.txt) \
--service-cidr=10.96.0.0/16 \
--pod-network-cidr=192.168.2.0/16
```

如果操作出错可以使用`echo y | kubeadm reset`
