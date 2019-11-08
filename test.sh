#!/bin/bash
sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum -y install http://repo.mysql.com/mysql57-community-release-el7.rpm
sudo yum -y install https://github.com/rabbitmq/erlang-rpm/releases/download/v20.1.7/erlang-20.1.7-1.el7.centos.x86_64.rpm
sudo curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash
sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
sudo echo "[elasticsearch-5.x]
name=Elasticsearch repository for 5.x packages
baseurl=https://artifacts.elastic.co/packages/5.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md" >> /etc/yum.repos.d/elasticsearch.repo

bash /root/git_cookbookcreate_nginx_repo.sh
sudo yum -y update nss openssl
sudo echo "[moogsoft-aiops]
name=moogsoft-aiops-latest
baseurl=https://moogcrest:gDaJRrua_8_k@speedy.moogsoft.com/repo/aiops/esr
enabled=1
gpgcheck=0
sslverify=0" >> /etc/yum.repos.d/moogsoft-aiops.repo

sudo setenforce 0


sudo yum -y install moogsoft-db \
    moogsoft-common \
    moogsoft-integrations \
    moogsoft-integrations-ui \
    moogsoft-mooms \
    moogsoft-search \
    moogsoft-server \
    moogsoft-ui \
    moogsoft-utils
sudo echo "export MOOGSOFT_HOME=/usr/share/moogsoft
export JAVA_HOME=/usr/java/latest
export APPSERVER_HOME=/usr/share/apache-tomcat
export PATH=$PATH:$MOOGSOFT_HOME/bin:$MOOGSOFT_HOME/bin/utils" >> ~/.bashrc
source ~/.bashrc
echo '' | $MOOGSOFT_HOME/bin/utils/moog_init.sh -I MY_ZONE -u root -q --accept-eula
service moogfarmd start
$MOOGSOFT_HOME/bin/utils/moog_install_validator.sh
$MOOGSOFT_HOME/bin/utils/tomcat_install_validator.sh
$MOOGSOFT_HOME/bin/utils/moog_db_validator.sh
systemctl status moogfarmd
systemctl status apache-tomcat
systemctl status rabbitmq-server
systemctl status mysqld

