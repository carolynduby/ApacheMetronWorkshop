script_dir=
wget http://s3.amazonaws.com/alexa-static/top-1m.csv.zip
unzip top-1m.csv.zip
head -n 10000 top-1m.csv > top-10k.csv

/usr/hcp/current/metron/bin/flatfile_summarizer.sh -i top-10k.csv -e extractor_count.json -p 5 -om CONSOLE

/usr/hcp/current/metron/bin/flatfile_summarizer.sh -i top-10k.csv -o /tmp/reference/alexa10k_filter.ser -e extractor_filter.json -p 5 -om HDFS
