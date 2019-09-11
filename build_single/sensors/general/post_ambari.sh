#!/bin/sh

source /etc/default/metron
sudo -E su hdfs -c "/usr/hcp/current/metron/bin/maxmind_enrichment_load.sh -z ${ZOOKEEPER}" 
