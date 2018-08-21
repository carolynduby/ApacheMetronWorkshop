curl -H "X-Requested-By: ambari" -X POST -u admin:admin http://localhost:8080/api/v1/blueprints/single-node-hcp-cluster -d @metron_cluster_blueprint.json
curl -H "X-Requested-By: ambari" -X POST -u admin:admin http://localhost:8080/api/v1/clusters/metron -d @hostmapping.json
