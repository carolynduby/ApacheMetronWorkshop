gendir=$1
hostmap=$2
blueprint=$3
curl -H "X-Requested-By: ambari" -X POST -u admin:admin http://localhost:8080/api/v1/blueprints/single-node-hcp-cluster -d @$gendir/$blueprint
curl -H "X-Requested-By: ambari" -X POST -u admin:admin http://localhost:8080/api/v1/clusters/metron -d @$gendir/$hostmap
