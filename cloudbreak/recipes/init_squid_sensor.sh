homedir=`getent passwd root | cut -d: -f6`

cd ${homedir}/repos/ApacheMetronWorkshop/build_single/sensors/squid/
./post_ambari.sh
