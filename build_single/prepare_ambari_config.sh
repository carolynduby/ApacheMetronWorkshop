gen_dir=`mktemp -p . -d genconfig.XXXXXXXXXX`
varfile=single-node-es-blueprint-19-variables.txt
hostmap=single-node-hostmapping.json
blueprint=single-node-es-blueprint-19.json

cp $hostmap $gen_dir
cp $blueprint $gen_dir
 
## replace the host name with the vm host name
host_replace="s/{{{my_hostname}}}/$HOSTNAME/g"
sed -i $host_replace $gen_dir/$hostmap 

while IFS="=" read -r key value; do 
   case "$key" in 
       '#'*) ;;
       *)
          sed -i "s/{{{$key}}}/$value/g" $gen_dir/$blueprint
   esac
done < "$varfile"
