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

5. Register the Blueprint and start the services. 

```
./register_blueprint.sh
curl -H "X-Requested-By: ambari" -X GET -u admin:admin http://localhost:8080/api/v1/clusters/metron/requests/1 | grep -e status -e percent -e queue -e fail
```

6. Wait for the cluster install to finish.  You can either open the Ambari UI or use the curl request below to check the status from the command line.

```
curl -H "X-Requested-By: ambari" -X GET -u admin:admin http://localhost:8080/api/v1/clusters/metron/requests/1 | grep -e status -e percent -e queue -e fail
```

7. Nifi will fail on startup.  There are a few passwords you need to enter.  
7a. Open Ambari.  Open the Nifi Configs and locate the "Encrypt Configuration Master Key Password".  Enter any recommended 12 character password.

8. In Ambari, open the Metron REST service configs and set Metron JDBC password to metron.

9. Restart Nifi and Metron REST services.  Restart any services that are not running.

10. Install the sample sensors.

```
cd typosquat
bash -x ./install_squid_enrichments.sh 2>&1 | tee -a install_squid_enrichments.log
```

11. Install the Nifi flow template.  Open the Nifi console:

```
http://<hostname>:9090/nifi
```

12. From the Nifi console upload the template metron_squidtokafka.xml nifi template.

13. Add the metron_squidtokafka.xml template to the Nifi canvas.

14. Configure your browser to generate some squid traffic.

15. Start the Nifi processors to move the squid logs to Kafka.
 
16. Verify that the squid logs appear in the Metron alerts UI.


