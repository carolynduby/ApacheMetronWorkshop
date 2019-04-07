ambari_up=0
until [ "$ambari_up" -eq "1" ];
do
 echo "Waiting for Ambari to bind to port..."
 sleep 5
 ambari_up=$(netstat -tulpn | grep 8080 | wc -l)
done
echo "Waiting 120s..."
sleep 120

export ambari_user=admin
export ambari_pass=admin
export log="/var/log/hdp_startup.log"
#detect name of cluster
output=`curl -s -u ${ambari_user}:${ambari_pass} -i -H 'X-Requested-By: ambari'  http://localhost:8080/api/v1/clusters`
cluster_name=`echo $output | sed -n 's/.*"cluster_name" : "\([^\"]*\)".*/\1/p'`
echo "Starting cluster ${cluster_name}..." >> ${log}
#form start_cmd
read -r -d '' start_cmd <<EOF
curl -u ${ambari_user}:${ambari_pass} -i -H "X-Requested-By: blah" -X PUT -d  '{"RequestInfo":{"context":"_PARSE_.START.ALL_SERVICES","operation_level":{"level":"CLUSTER","cluster_name":"'"${cluster_name}"'"}},"Body":{"ServiceInfo":{"state":"STARTED"}}}' http://localhost:8080/api/v1/clusters/${cluster_name}/services
EOF
#run command and get request id
echo "Requesting Ambari to start all.." >> ${log}
req_output=$(eval ${start_cmd})
req=$(echo ${req_output} | sed -n 's/.*"id" : \([0-9]*\),.*/\1/p')
#check status of request using its id
read -r -d '' status_cmd <<EOF
curl -u ${ambari_user}:${ambari_pass} -i -H "X-Requested-By: blah" -X GET http://localhost:8080/api/v1/clusters/${cluster_name}/requests/${req} | sed -n 's/.*"request_status" : "\([^\"]*\)".*/\1/p'
EOF
status=$(eval $status_cmd)
echo "status of request ${req} is ${status}"
#wait until request processing completed
until ([ "$status" != "IN_PROGRESS" ] && [ "$status" != "PENDING" ]);
do
 echo "Waiting for start all operation to complete..." >> ${log}
 sleep 5
 status=$(eval $status_cmd)
done
#check last status: if request failed, retry once
if [ "${status}" == "FAILED" ]; then
  echo "Start all failed. Retrying operation once more..." >> ${log}
  sleep 5
  eval ${start_cmd} >> ${log}
elif [ "${status}" == "COMPLETED" ]; then
   echo "Start all operation completed. Cluster is ready" >> ${log}
else
   echo "Operation did not succeed. Status was ${status}" >> ${log}
fi

if [ -e "/usr/hdp/current/knox-server/bin/gateway.sh" ]; then
  echo "starting Knox..." >> /var/log/hdp_startup.log
  mkdir /var/run/knox
  chown knox:hadoop /var/run/knox
  sudo -u knox /usr/hdp/current/knox-server/bin/gateway.sh start
  sudo -u knox /usr/hdp/current/knox-server/bin/ldap.sh start
fi
