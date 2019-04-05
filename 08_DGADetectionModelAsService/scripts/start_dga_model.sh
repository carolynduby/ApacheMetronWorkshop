sudo /usr/hcp/current/metron/bin/maas_service.sh -zq localhost:2181 
sudo /usr/hcp/current/metron/bin/maas_deploy.sh -hmp /user/root/models -mo ADD -m 750 -n dga -v 1.0 -ni 1 -zq localhost:2181 -lmp /root/dga_model
