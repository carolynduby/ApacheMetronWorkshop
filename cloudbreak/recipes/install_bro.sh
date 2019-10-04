#!/bin/sh
source /etc/default/metron

# setup bro yum repo
pushd /etc/yum.repos.d/
wget http://download.opensuse.org/repositories/network:bro/CentOS_7/network:bro.repo
popd

# install bro
yum -y install bro

# install prereqs
sudo yum -y install cmake make gcc gcc-c++ flex bison libpcap-devel openssl-devel python-devel swig zlib-devel
git clone https://github.com/apache/metron-bro-plugin-kafka

# install librdkafka
mkdir librdkafka
pushd librdkafka/
wget https://github.com/edenhill/librdkafka/archive/v0.11.5.tar.gz
gunzip v0.11.5.tar.gz
tar xvf v0.11.5.tar
pushd librdkafka-0.11.5/
./configure --enable-sasl
make
make install
popd
popd

# install bro-pkg
pip install setuptools -U
pip install future
pip install bro-pkg
pip install git+git://github.com/bro/package-manager@master
export PATH="/opt/bro/bin/:$PATH"
bro-pkg autoconfig

## load packages at the end of /opt/bro/share/bro/site/local.bro
echo "@load packages" >> /opt/bro/share/bro/site/local.bro
echo "redef Kafka::logs_to_send = set(DNS::LOG);" >> /opt/bro/share/bro/site/local.bro
echo "redef Kafka::tag_json = T;" >> /opt/bro/share/bro/site/local.bro
echo "redef Kafka::kafka_conf = table(" >> /opt/bro/share/bro/site/local.bro
echo "    [\"metadata.broker.list\"] = \"${BROKERLIST}\"" >> /opt/bro/share/bro/site/local.bro
echo ");" >> /opt/bro/share/bro/site/local.bro

# install bro from source
bro_binary_version=`rpm -qa | grep bro- | grep -v core | cut -d"-" -f2`
wget https://www.zeek.org/downloads/bro-${bro_binary_version}.tar.gz
gunzip bro-${bro_binary_version}.tar.gz
tar xvf bro-${bro_binary_version}.tar
pushd bro-${bro_binary_version}
./configure
make
make install
popd

## add source code to zeek config 
sed -i "s/zeek_dist =/zeek_dist = \/root\/bro-${bro_binary_version}/" /root/.zkg/config

bro-pkg install apache/metron-bro-plugin-kafka --version master --force

## don't send mail
sed -i 's/MailTo = root@localhost/MailTo = /' /opt/bro/etc/broctl.cfg

## set the interface to tap0
sed -i 's/interface=eth0/interface=tap0/' /opt/bro/etc/node.cfg

## start the tap interface
ip tuntap add tap0 mode tap
ifconfig tap0 up
ip link set tap0 promisc on

broctl install
broctl start

