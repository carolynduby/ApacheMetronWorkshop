gendir=$1
varfile=$2
hostmap=$3
blueprint=$4

cp $hostmap $gendir
cp $blueprint $gendir
 
## replace the host name with the vm host name
host_replace="s/{{{my_hostname}}}/$HOSTNAME/g"
sed -i $host_replace $gendir/$hostmap 

while IFS="=" read -r key value; do 
   case "$key" in 
       '#'*) ;;
       *)
          sed -i "s/{{{$key}}}/$value/g" $gendir/$blueprint
   esac
done < "$varfile"
