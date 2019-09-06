#install epel repo
sudo yum -y install epel-release

# install prereqs
sudo yum install wget -y
sudo yum install net-tools -y

#install nodejs
curl --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -
sudo yum install -y nodejs

#install mysql
wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
sudo rpm -ivh mysql-community-release-el7-5.noarch.rpm
sudo yum -y install mysql-community-server
sudo yum -y install mysql-connector-java
sudo service mysqld start

mysql -u root < mysql_init_users.sql 
echo "grant all privileges on *.* to 'hive'@'"`hostname`"' identified by 'admin';" | mysql -u root

#change the root pw
sudo mysqladmin -u root password root

# correct the python-requests version so metron service status displays correct results
sudo yum -y install python-pip
sudo pip install requests==2.6.1
sudo service ambari-agent restart

## add autorestart command
sudo cp start_service.sh /root
sudo sh -c "echo 'bash /root/start_service.sh' >> /etc/rc.local"
sudo chmod a+x /etc/rc.d/rc.local

# set umask
sudo umask 0022

# configure the machine and install ambari
export ambari_version="2.6.2.2"
export install_ambari_server=true
curl -sSL https://raw.githubusercontent.com/seanorama/ambari-bootstrap/master/ambari-bootstrap.sh | sudo -E sh
 
wget -nv http://public-repo-1.hortonworks.com/HCP/centos7/1.x/updates/1.9.1.0/tars/metron/hcp-ambari-mpack-1.9.1.0-6.tar.gz 
wget -nv http://public-repo-1.hortonworks.com/HCP/centos7/1.x/updates/1.9.1.0/tars/metron/elasticsearch_mpack-1.9.1.0-6.tar.gz 
wget -nv http://public-repo-1.hortonworks.com/HDF/centos7/3.x/updates/3.1.2.0/tars/hdf_ambari_mp/hdf-ambari-mpack-3.1.2.0-7.tar.gz
wget -nv http://public-repo-1.hortonworks.com/HDP-SOLR/hdp-solr-ambari-mp/solr-service-mpack-3.0.0.tar.gz

sudo ambari-server install-mpack --mpack=hcp-ambari-mpack-1.9.1.0-6.tar.gz --verbose
sudo ambari-server install-mpack --mpack=elasticsearch_mpack-1.9.1.0-6.tar.gz --verbose
sudo ambari-server install-mpack --mpack=hdf-ambari-mpack-3.1.2.0-7.tar.gz --verbose
sudo ambari-server install-mpack --mpack=solr-service-mpack-3.0.0.tar.gz --verbose
sudo ambari-server setup --jdbc-db=mysql --jdbc-driver=/usr/share/java/mysql-connector-java.jar

sudo ambari-server restart


# install the demo content
# don't run this yet, we need to setup metron with blueprint first
# cd typosquat
# ./install_squid_enrichments.sh
