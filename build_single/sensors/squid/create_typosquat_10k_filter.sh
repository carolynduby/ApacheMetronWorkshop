#!/bin/sh

source /etc/default/metron

wget http://downloads.majestic.com/majestic_million.csv 
tail -n +2 majestic_million.csv | head -n 10000 > top-10k.csv
sed "s/ZK_QUORUM/${ZOOKEEPER}/" extractor_count.json.template > extractor_count.json
sed "s/ZK_QUORUM/${ZOOKEEPER}/" extractor_filter.json.template > extractor_filter.json
 
/usr/hcp/current/metron/bin/flatfile_summarizer.sh -i top-10k.csv -e extractor_count.json -p 5 -om CONSOLE

hdfs dfs -mkdir -p /apps/metron/reference
/usr/hcp/current/metron/bin/flatfile_summarizer.sh -i top-10k.csv -o /apps/metron/reference/top10k_typosquat_filter.ser -e extractor_filter.json -p 5 -om HDFS
