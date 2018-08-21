export SOLR_HOME=/opt/lucidworks-hdpsearch/solr/
export SOLR_USER=solr
export METRON_HOME=/usr/hcp/current/metron/config/schema/

sudo su $SOLR_USER -c "$SOLR_HOME/bin/solr create -c error -d $METRON_HOME/config/schema/error/"
sudo su $SOLR_USER -c "$SOLR_HOME/bin/solr create -c metaalert -d $METRON_HOME/config/schema/metaalert/"

su $SOLR_USER -c "$SOLR_HOME/bin/solr create -c bro -d $METRON_HOME/config/schema/bro/"

