
## add autorestart command
sudo cp start_service.sh /home/centos
sudo sh -c "echo 'bash /home/centos/start_service.sh' >> /etc/rc.local"
sudo chmod a+x /etc/rc.d/rc.local

#install epel repo
sudo yum -y install epel-release

# set umask
sudo umask 0022

# install mysql and start
wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
sudo rpm -ivh mysql-community-release-el7-5.noarch.rpm
sudo yum -y install mysql-community-server
sudo systemctl enable mysqld
sudo systemctl start mysqld

# Set up the metron users
mysql -u root < hcp_metron_rest_db.sql

# install mysql connector
sudo yum -y install mysql-connector-java*
ls -al /usr/share/java/mysql-connector-java.jar

# configure the machine and install ambari
export ambari_version="2.6.2.2"
export install_ambari_server=true
curl -sSL https://raw.githubusercontent.com/seanorama/ambari-bootstrap/master/ambari-bootstrap.sh | sudo -E sh

# register mysql with ambari
sudo ambari-server setup --jdbc-db=mysql --jdbc-driver=/usr/share/java/mysql-connector-java.jar
 
wget http://public-repo-1.hortonworks.com/HCP/centos7/1.x/updates/1.6.0.0/tars/metron/hcp-ambari-mpack-1.6.0.0-7.tar.gz
wget http://public-repo-1.hortonworks.com/HDP-SOLR/hdp-solr-ambari-mp/solr-service-mpack-3.0.0.tar.gz
wget http://public-repo-1.hortonworks.com/HDF/centos7/3.x/updates/3.1.2.0/tars/hdf_ambari_mp/hdf-ambari-mpack-3.1.2.0-7.tar.gz

sudo ambari-server install-mpack --mpack=hcp-ambari-mpack-1.6.0.0-7.tar.gz --verbose
sudo ambari-server install-mpack --mpack=solr-service-mpack-3.0.0.tar.gz --verbose
sudo ambari-server install-mpack --mpack=hdf-ambari-mpack-3.1.2.0-7.tar.gz --verbose

sudo ambari-server restart

# correct the python-requests version so metron service status displays correct results
sudo rpm -e --nodeps python-requests
sudo yum -y install python-pip
sudo pip install requests
sudo service ambari-agent restart

# install the demo content
# don't run this yet, we need to setup metron with blueprint first
# cd typosquat
# ./install_squid_enrichments.sh
