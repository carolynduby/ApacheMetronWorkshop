#!/bin/sh

squid_schema_dir=/usr/hcp/current/metron/config/schema/squid
sudo mkdir ${squid_schema_dir} 
sudo chmod a+rx ${squid_schema_dir}
sudo cp ApacheMetronWorkshop/02_ParsingSquid/solr/* ${squid_schema_dir} 
ApacheMetronWorkshop/build_single/typosquat/create_solr_collection.sh squid

