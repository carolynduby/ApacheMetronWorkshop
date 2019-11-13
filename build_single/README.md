# Introduction

The scripts in this directory install and configure a single node metron from a Centos 7 host.

# Provision the host 

Create a host running Centos 7.  The user you use must be able to sudo. 

# Install the single node HCP

To use the scripts:

1. Install git 

```
sudo yum -y install git 
```

2. Get the scripts.

```
git clone https://github.com/carolynduby/ApacheMetronWorkshop.git 
```

3. If running in AWS and you want to set the hostname, run the sethostname script and allow the host to reboot.  If not running in AWS, skip this step or use cloud specific scripts to set the desired host name.   

```
cd ApacheMetronWorkshop-master/build_single/
./sethostname.sh
```

4. Select the index type to use (es or solr).  Substitute the CHANGEME text with your passwords. Passwords requiring at least 12 characters are noted. 

```
vi single-node-<index type>-blueprint-19-variables.txt
```

4. Log into the host and run the buld script.  The build script output will print to the console and be logged to build_single.log.

```
cd ApacheMetronWorkshop-master/build_single/
bash -x ./build_single.sh 2>&1 | tee -a build_single.log
```

5. Register the Blueprint and start the services. 

```
./deploy_single_node.sh <es or solr>
```

6. Wait for the cluster install to finish.  You can either open the Ambari UI or use the curl request below to check the status from the command line.

```
curl -H "X-Requested-By: ambari" -X GET -u admin:admin http://localhost:8080/api/v1/clusters/metron/requests/1 | grep -e status -e percent -e queue -e fail
```


