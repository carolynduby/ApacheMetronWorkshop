if [ $# -ne 1 ]; then 
    echo "Usage: " $0 " index_type(es|solr)"
    exit 1
fi

#index type must be es or solr
if [ "$index_type" != "es" -a "$index_type" != "solr" ]; then
     echo "ERROR: index type argument must be es or solr." 
     exit 1
fi 

index_type=$1
gendir=`mktemp -p . -d genconfig.XXXXXXXXXX`
varfile=single-node-${index_type}-blueprint-19-variables.txt
hostmap=single-node-hostmapping.json
blueprint=single-node-${index_type}-blueprint-19.json

## replace the passwords in the blueprint with the variables
./prepare_ambari_config.sh $gendir $varfile $hostmap $blueprint

## print out the generated directory
echo 'generated_directory = ' $gendir

## register the blueprint
./register_blueprint.sh $gendir $hostmap $blueprint
