if [ "$#" -ne 2 ]; then 
    echo "Usage: $0 <process_group_name> <flow_template file>"
    exit 1
fi

nifi_hostname=`hostname`
process_group_name=$1
flow_template_file=$2

if [ ! -f "$flow_template_file" ]; then 
   echo "Error: Flow template '"$2"' does not exist."
   exit 1
fi

# get the client id
client_id=`curl -X GET -H "Accept: */*" -H "Accept-Encoding: gzip" -H "Accept-Language: en-US,en;q=0.5" -H "Connection: keep-alive" -H "Host: ${nifi_hostname}:9090" -H "Referer: http://${nifi_hostname}:9090/nifi/login" -H "X-Requested-With: XMLHttpRequest" http://${nifi_hostname}:9090/nifi-api/flow/client-id | gunzip`

# get the root process group uri
root_process_group=`curl -X GET -H "Accept: */*" -H "Accept-Encoding: gzip" -H "Accept-Language: en-US,en;q=0.5" -H "Connection: keep-alive" -H "Host: ${nifi_hostname}:9090" -H "Referer: http://${nifi_hostname}:9090/nifi/login" -H "X-Requested-With: XMLHttpRequest" http://${nifi_hostname}:9090/nifi-api/flow/process-groups/root | gunzip`

root_process_group=`echo $root_process_group | python nifi_get_root_node.py`

# add a process group to the root
new_process_group=`curl -X POST -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Accept-Encoding: gzip" -H "Accept-Language: en-US,en;q=0.5" -H "Connection: keep-alive"  -H "Content-Type: application/json" -H "Host: ${nifi_hostname}:9090" -H "Referer: http://${nifi_hostname}:9090/nifi/login" -H "X-Requested-With: XMLHttpRequest" -d '{"revision":{"clientId":"'"${client_id}"'","version":0},"component":{"name":"'${process_group_name}'","position":{"x":299.0,"y":1340.0}}}' http://${nifi_hostname}:9090/nifi-api/process-groups/${root_process_group}/process-groups | gunzip`

# get the process group id out of the json response
new_process_group=`echo $new_process_group | python nifi_get_id.py`

# add the template
new_template=`curl -X POST -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Accept-Language: en-US,en;q=0.5" -H "Connection: keep-alive"  -H "Host: ${nifi_hostname}:9090" -H "Referer: http://${nifi_hostname}:9090/nifi/login" -H "X-Requested-With: XMLHttpRequest" -F template=@${flow_template_file} http://${nifi_hostname}:9090/nifi-api/process-groups/${new_process_group}/templates/upload | sed -e 's/^.*<id>//' -e 's/<\/id>.*$//'`

# instantiate the template in the new process group
template_instance=`curl -X POST -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Accept-Encoding: gzip" -H "Accept-Language: en-US,en;q=0.5" -H "Connection: keep-alive"  -H "Content-Type: application/json" -H "Host: ${nifi_hostname}:9090" -H "Referer: http://${nifi_hostname}:9090/nifi/login" -H "X-Requested-With: XMLHttpRequest" -d '{"templateId":"'"${new_template}"'","originX":454.00000980985635,"originY":194.99994834216295}' http://${nifi_hostname}:9090/nifi-api/process-groups/${new_process_group}/template-instance | gunzip`

# return the id of the new process group
echo $new_process_group

