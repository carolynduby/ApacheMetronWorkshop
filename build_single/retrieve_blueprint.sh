export METRON_HOST=13.56.232.18
curl -H "X-Requested-By: ambari" -X GET -u admin:admin http://$METRON_HOST:8080/api/v1/clusters/metron?format=blueprint > /tmp/metron_cluster_blueprint.json
