sudo hostnamectl set-hostname --static mobius.local.localdomain
sudo sed -i 's/NETWORKING=yes$/HOSTNAME=mobius.local.localdomain\nNETWORKING=yes/' /etc/sysconfig/network
sudo sed -i '0,/localhost/{s/localhost/mobius.local.localdomain mobius.local localhost/}' /etc/hosts
sudo bash -c "echo 'preserve_hostname: true' >> /etc/cloud/cloud.cfg"
sudo reboot
