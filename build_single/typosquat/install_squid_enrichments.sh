## create the typosquat filter
./create_typosquat_10k_filter.sh

## create the squid topic
/usr/hdp/current/kafka-broker/bin/kafka-topics.sh --zookeeper localhost:2181 --create --topic squid --partitions 1 --replication-factor 1

## get the current sensor settings 
sudo /usr/hcp/current/metron/bin/zk_load_configs.sh -z localhost:2181 -m PULL -f -o /usr/hcp/current/metron/config/zookeeper 
## set the squid enrichements with typosquat detection
sudo cp squid_enrichments.json /usr/hcp/current/metron/config/zookeeper/enrichments/squid.json
## push the squid_enrichments json into zookeeper
sudo /usr/hcp/current/metron/bin/zk_load_configs.sh -z localhost:2181 -m PUSH -i /usr/hcp/current/metron/config/zookeeper 

# install squid proxy and set it to run on reboot
sudo yum -y install squid

# modify the config to allow outside requests
sudo sed  -i 's/http_access allow localhost$/http_access allow localhost\n\n# allow all requests\nacl all src 0.0.0.0\/0\nhttp_access allow all/' /etc/squid/squid.conf

# start the service and enable it to run after reboot
sudo systemctl start squid
sudo systemctl enable squid


export ZOOKEEPER_CONFIG_PATH=/usr/hcp/current/metron/config/zookeeper
## get the current metron configs
sudo /usr/hcp/current/metron/bin/zk_load_configs.sh -z localhost:2181 -m PULL -f -o $ZOOKEEPER_CONFIG_PATH 
## insert the squid typosquat enrichments
sudo cp squid_enrichments.json $ZOOKEEPER_CONFIG_PATH/enrichments/squid.json
## install the squid_enrichments json in zookeeper
sudo /usr/hcp/current/metron/bin/zk_load_configs.sh -z localhost:2181 -m PUSH -i $ZOOKEEPER_CONFIG_PATH 

/usr/hdp/current/kafka-broker/bin/kafka-topics.sh --zookeeper localhost:2181 --create --topic squid --partitions 1 --replication-factor 1

# allow nifi to read squid logs
sudo usermod -a -G squid nifi

# install the solr squid template
export SOLR_HOME=/opt/lucidworks-hdpsearch/solr/
export SOLR_USER=solr
export METRON_HOME=/usr/hcp/current/metron
export ZOOKEEPER=localhost:2181/solr

sudo mkdir /usr/hcp/current/metron/config/schema/squid
sudo cp ../../02_ParsingSquid/solr/* /usr/hcp/current/metron/config/schema/squid
sudo -E su $SOLR_USER -c "$METRON_HOME/bin/create_collection.sh squid"

# put the mysquid templates in place but don't create the collection yet.  this will be done in the labs
sudo cp -r /usr/hcp/current/metron/config/schema/squid /usr/hcp/current/metron/config/schema/mysquid
sudo sed  -i 's/squid_doc/mysquid_doc/' /usr/hcp/current/metron/config/schema/mysquid/schema.xml 

sudo -E su hdfs -c "$METRON_HOME/bin/geo_enrichment_load.sh -z localhost:2181"

cp create_solr_collection.sh /home/centos 
