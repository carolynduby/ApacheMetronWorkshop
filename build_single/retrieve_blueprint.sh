export METRON_HOST=metron-demo-0.field.hortonworks.com
curl -H "X-Requested-By: ambari" -X GET -u admin:admin http://$METRON_HOST:8080/api/v1/clusters/metrondemo?format=blueprint > /tmp/metron_cluster_blueprint.json
