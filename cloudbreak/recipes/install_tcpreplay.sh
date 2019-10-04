#!/bin/sh

sudo yum -y install tcpdump gcc bind-utils libpcap-devel
wget https://github.com/appneta/tcpreplay/releases/download/v4.3.1/tcpreplay-4.3.1.tar.xz
tar xJf tcpreplay-4.3.1.tar.xz 

pushd tcpreplay-4.3.1
./configure
make
sudo make install
popd
