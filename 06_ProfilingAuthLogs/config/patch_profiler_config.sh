wget -P /tmp/zkprof https://github.com/simonellistonball/metron-field-demos/raw/master/profiler_patch.py
sudo -- bash -c 'cat zookeeper/profiler.json | python /tmp/zkprof/profiler_patch.py > /tmp/zkconfig/profiler_patch.json'
sudo $METRON_HOME/bin/zk_load_configs.sh -z $ZOOKEEPER -m PATCH -c PROFILER -pf /tmp/zkconfig/profiler_patch.json


