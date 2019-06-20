echo $INSTALLED_SENSORS

# install squid proxy and set it to run on reboot
sudo yum -y install squid

# modify the config to allow outside requests
sudo sed  -i 's/http_access allow localhost$/http_access allow localhost\n\n# allow all requests\nacl all src 0.0.0.0\/0\nhttp_access allow all/' /etc/squid/squid.conf

# start the service and enable it to run after reboot
sudo systemctl start squid
sudo systemctl enable squid


