#!/bin/sh 

source /etc/default/metron

./demo_loader.sh -e 1848158 -c config.json -z $ZOOKEEPER -hf host_filter.txt
