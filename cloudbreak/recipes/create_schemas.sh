#!/bin/sh

homedir=`getent passwd root | cut -d: -f6`
schema_dir=/usr/hcp/current/metron/config/schema

# stage solr schemas
mkdir ${schema_dir}/squid
cp ${homedir}/repos/ApacheMetronWorkshop/02_ParsingSquid/solr/* ${schema_dir}/squid

chmod -R a+r ${schema_dir}

# create the collections
${homedir}/repos/ApacheMetronWorkshop/build_single/typosquat/create_solr_collection.sh squid

