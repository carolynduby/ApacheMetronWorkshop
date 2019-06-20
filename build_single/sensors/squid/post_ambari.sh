pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}

# create the alexa 10 typosquat bloom filter
./create_typosquat_10k_filter.sh

# allow nifi to read squid logs
sudo usermod -a -G squid nifi

# install the domain whitelist
cp ../../../04_TriagingSquid/scripts/* /home/centos
pushd /home/centos
./import_domain_whitelist.sh
popd
