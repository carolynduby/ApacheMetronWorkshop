export SOLR_HOME=/opt/lucidworks-hdpsearch/solr/
export SOLR_USER=solr
export METRON_HOME=/usr/hcp/current/metron
cd $SOLR_HOME
sudo -E su $SOLR_USER -c "bin/solr create_collection -c $1 -d $METRON_HOME/config/schema/$1/ -p 8983"
