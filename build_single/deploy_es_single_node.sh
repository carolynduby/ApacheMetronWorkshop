gendir=`mktemp -p . -d genconfig.XXXXXXXXXX`
varfile=single-node-es-blueprint-19-variables.txt
hostmap=single-node-hostmapping.json
blueprint=single-node-es-blueprint-19.json

## replace the passwords in the blueprint with the variables
./prepare_ambari_config.sh $gendir $varfile $hostmap $blueprint

## print out the generated directory
echo 'generated_directory = ' $gendir

## register the blueprint
./register_blueprint.sh $gendir $hostmap $blueprint
