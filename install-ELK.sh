#!/bin/bash

function header () {
	cat<<EOF

###############################################################################
 $1
###############################################################################
EOF
}

TZ=UTC
ELK_VERSION=6

header "Set TZ"
timedatectl set-timezone $TZ

header "ELK v$ELK_VERSION INSTALLER"

# to accept the java lience
header "pre-reqs apps"
apt-get install -y software-properties-common python-software-properties debconf-utils apt-transport-https

# java repo
header "setup java repo"
add-apt-repository -y ppa:webupd8team/java

# ELK repos 
header "setup ELK repos"
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/${ELK_VERSION}.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-${ELK_VERSION}.x.list

# collectd repo
header "setup collectd repo"
wget -qO - https://pkg.ci.collectd.org/pubkey.asc | sudo apt-key add -    
echo "deb http://pkg.ci.collectd.org/deb xenial collectd-5.6" | sudo tee -a /etc/apt/sources.list.d/collectd.list


# update repos metdata
header "update repos"
apt-get update

# install java
header "install java8"
echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
apt-get -q install -y oracle-java8-installer

# required for logstash
header "JAVA envvars"
export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"
echo 'export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"' | tee -a /etc/profile

# install everything else
header "install everything else"
apt-get install -y elasticsearch 
apt-get install -y kibana
apt-get install -y logstash
apt-get install -y collectd

# java reqs
header "sysctl"
sysctl -w vm.max_map_count=262144

# copy configs
header "copy configs"
cp -v /vagrant/elasticsearch.yml /etc/elasticsearch/
cp -v /vagrant/kibana.yml /etc/kibana/
cp -v /vagrant/logstash-collectd.conf /etc/logstash/conf.d/
cp -v /vagrant/collectd.conf /etc/collectd/

# install plugins
header "install plugins - this is very slow"
echo " ++ x-pack for elastic search"
/usr/share/elasticsearch/bin/elasticsearch-plugin install --silent x-pack
echo " ++ x-pack for kibana"
/usr/share/kibana/bin/kibana-plugin install --quiet x-pack

# start services
header "enable and start services"
/bin/systemctl daemon-reload
/bin/systemctl enable kibana.service
/bin/systemctl enable elasticsearch.service
/bin/systemctl enable logstash.service

/bin/systemctl restart logstash.service   
/bin/systemctl restart elasticsearch.service   
/bin/systemctl restart kibana.service
/bin/systemctl restart collectd.service

# test access
header "test access"
wget -O - http://127.0.0.1:9200/

