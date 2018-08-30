export SOLR_HOME=/opt/lucidworks-hdpsearch/solr/
export SOLR_USER=solr
export METRON_HOME=/usr/hcp/current/metron
export ZOOKEEPER=localhost:2181/solr
sudo -E su $SOLR_USER -c "$METRON_HOME/bin/create_collection.sh $1"
