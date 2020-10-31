cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
sudo sed -e 's|^mirrorlist=|#mirrorlist=|g' \
         -e 's|^#baseurl=http://mirror.centos.org/centos|baseurl=https://mirrors.ustc.edu.cn/centos|g' \
                  -i.bak \
                           /etc/yum.repos.d/CentOS-Base.repo
#curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg
       http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables=1
net.bridge.bridge-nf-call-iptables=1
net.ipv4.ip_forward=1
EOF
sysctl -p /etc/sysctl.d/k8s.conf
yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

yum makecache
yum install -y vim
yum install -y yum-utils

yum install -y docker-ce docker-ce-cli containerd.io

if [ ! -d /etc/docker ];then
    mkdir /etc/docker
fi
cat <<EOF > /etc/docker/daemon.json 
{
    "registry-mirrors": ["https://h8utl1yg.mirror.aliyuncs.com"]
}
EOF

systemctl status docker
systemctl enable docker
systemctl start docker
systemctl status docker

containerd_version="1.3.7-3.1.el7"
kube_version="1.19.3-0"
yum install -y kubelet-$kube_version kubeadm-$kube_version kubectl-$kube_version --disableexcludes=kubernetes

images_list=$(kubeadm config images list 2> /dev/null)
for name in $images_list; do
     echo ${name: 11};  
     imageName=${name: 11}
     docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName
     docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName k8s.gcr.io/$imageName
     docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName
done

