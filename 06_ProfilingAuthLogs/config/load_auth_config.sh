source /etc/default/metron

# install the auth configs
sudo $METRON_HOME/bin/zk_load_configs.sh -m PULL -z $ZOOKEEPER -o /tmp/zkconfig -f
sudo cp zookeeper/enrichments/auth.json /tmp/zkconfig/enrichments/
sudo cp zookeeper/parsers/auth.json /tmp/zkconfig/parsers/
sudo cp zookeeper/indexing/auth.json /tmp/zkconfig/indexing/

PROFILER_CONFIG_FILE=/tmp/zkconfig/profiler.json
PROFILER_PATCH_NEEDED=1
if [ ! -f $PROFILER_CONFIG_FILE ]; then
   sudo cp zookeeper/profiler.json /tmp/zkconfig/profiler.json
   echo "no profiler.json found.  adding auth profilers"
   PROFILER_PATCH_NEEDED=0 
fi

sudo $METRON_HOME/bin/zk_load_configs.sh -m PUSH -z $ZOOKEEPER -i /tmp/zkconfig 

if ((PROFILER_PATCH_NEEDED)); then
   echo "profiler.json found.  patching profilers"
   ./patch_profiler_config.sh
fi

