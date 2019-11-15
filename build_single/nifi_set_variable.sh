if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <processor id> <variable_name> <variable_value>" 
    exit 1
fi

nifi_hostname=`hostname`
process_group_id=$1
variable_name=$2
variable_value=$3

# get the client id
variable_registry_response=`curl -X GET -H "Accept: */*" -H "Accept-Encoding: gzip" -H "Accept-Language: en-US,en;q=0.5" -H "Connection: keep-alive" -H "Host: ${nifi_hostname}:9090" -H "Referer: http://${nifi_hostname}:9090/nifi/login" -H "X-Requested-With: XMLHttpRequest" http://${nifi_hostname}:9090/nifi-api/process-groups/${process_group_id}/variable-registry | gunzip`

client_id=`echo $variable_registry_response |  python nifi_get_variable_client_id.py`
client_version=`echo $variable_registry_response | python nifi_get_variable_client_version.py`

# set the variable
variable_response=`curl -X POST -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Accept-Encoding: gzip" -H "Accept-Language: en-US,en;q=0.5" -H "Connection: keep-alive"  -H "Content-Type: application/json" -H "Host: ${nifi_hostname}:9090" -H "Referer: http://${nifi_hostname}:9090/nifi/login" -H "X-Requested-With: XMLHttpRequest" -d '{"processGroupRevision":{"clientId":"'"${client_id}"'","version":'${client_version}'},"variableRegistry":{"processGroupId":"'${process_group_id}'","variables":[{"variable":{"name":"'${variable_name}'","value":"'${variable_value}'"}}]}}' http://${nifi_hostname}:9090/nifi-api/process-groups/${process_group_id}/variable-registry/update-requests | gunzip`

echo $variable_response
