source /etc/default/metron

today=`date +'%s.000'`
cat typosquat_domains.txt | awk -v todays_date=$today 'BEGIN {FS =","} {print todays_date"  66025 208.54.147.129 TCP_TUNNEL/200 7699 CONNECT " $1 ":443 - HIER_DIRECT/72.21.206.140 -"}' | /usr/hdp/current/kafka-broker/bin/kafka-console-producer.sh --topic squid --broker-list $BROKERLIST
