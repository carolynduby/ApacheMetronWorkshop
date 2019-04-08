mkdir -p /opt/lucidworks-hdpsearch/solr/banana-extra/resources/conf
cd /opt/lucidworks-hdpsearch/solr/banana-extra/resources/conf
wget https://raw.githubusercontent.com/lucidworks/banana/develop/resources/banana-int-solr-5.0/conf/schema.xml
cp -p /usr/hcp/current/metron/config/schema/bro/solrconfig.xml .
