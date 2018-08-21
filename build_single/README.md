# Introduction

The scripts in this directory install and configure a single node metron from a Centos 7 host.

To use the scripts:

1. Install wget and unzip if they are not already installed.

```
sudo yum -y install wget
sudo yum -y install unzip
```

2. Download and unzip the scripts.

```
wget -nv https://github.com/carolynduby/ApacheMetronWorkshop/archive/master.zip
unzip master.zip

```

3. Run the buld script.

```
cd ApacheMetronWorkshop-master/build_single/
./build_single.sh
```
