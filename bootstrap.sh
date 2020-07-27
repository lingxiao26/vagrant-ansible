#!/bin/sh -x

install_yumrepo() {
  centos_ver=$(rpm -q --queryformat '%{VERSION}' centos-release)
  sudo yum install curl -y
  sudo rm -rf /etc/yum.repos.d/*
  [ "${centos_ver%\.*}" -eq 7 ] && curl -so /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
  [ "${centos_ver%\.*}" -eq 6 ] && curl -so /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo
  [ "${centos_ver%\.*}" -eq 8 ] &&
    curl -so /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-8.repo &&
    sudo yum install -y https://mirrors.aliyun.com/epel/epel-release-latest-8.noarch.rpm &&
    sed -i 's|^#baseurl=https://download.fedoraproject.org/pub|baseurl=https://mirrors.aliyun.com|' /etc/yum.repos.d/epel* &&
    sed -i 's|^metalink|#metalink|' /etc/yum.repos.d/epel*

  sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo

  # curl -oL /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-8.repo
  # sudo yum install epel-release -y
  # yum update -y
  echo 'LANG="en_US.UTF-8"' >/etc/sysconfig/i18n
  export TZ='Asia/Shanghai'
  ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
}

install_ansible() {
  sudo yum install ansible -y
  sudo chmod 600 /home/vagrant/insecure_private_key
}

main() {
  install_yumrepo
  install_ansible
}

main
