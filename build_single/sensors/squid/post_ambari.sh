pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}

source /etc/default/metron
homedir=`getent passwd root | cut -d: -f6`

# create the alexa 10 typosquat bloom filter
./create_typosquat_10k_filter.sh

# allow nifi to read squid logs
sudo usermod -a -G squid nifi

# install the domain whitelist
cp ../../../04_TriagingSquid/scripts/* ${homedir} 
pushd ${homedir} 
sed "s/localhost:2181/${ZOOKEEPER}/" -i domain_whitelist_extractor_config.json
./import_domain_whitelist.sh
popd
