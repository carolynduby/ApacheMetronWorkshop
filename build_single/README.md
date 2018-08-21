# Introduction

The scripts in this directory install and configure a single node metron from a Centos 7 host.

# Provision the host 

Create a host running Centos 7.

# Install the single node HCP

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

3. Run the sethostname script and allow the host to reboot.

```
cd ApacheMetronWorkshop-master/build_single/
./sethostname.sh
```

4. Log into the host and run the buld script.  The build script output will print to the console and be logged to build_single.log.

```
cd ApacheMetronWorkshop-master/build_single/
bash -x ./build_single.sh 2>&1 | tee -a build_single.log
```
