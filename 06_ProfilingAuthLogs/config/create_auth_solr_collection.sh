source /etc/default/metron

# install the auth schema
sudo cp -r schema/auth $METRON_HOME/config/schema/
../../build_single/typosquat/create_solr_collection.sh auth

