# do this as root
sudo ./download_banana_schema.sh 

# do this as Solr
cd /opt/lucidworks-hdpsearch/solr/bin/
sudo -u solr ./solr create_collection -c banana-int -d /opt/lucidworks-hdpsearch/solr/banana-extra/resources/conf -p 8983
