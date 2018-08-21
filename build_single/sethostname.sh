sudo hostnamectl set-hostname mobius.local.localdomain
sudo sed -i 's/NETWORKING=yes$/HOSTNAME=mobius.local.localdomain\nNETWORKING=yes/' /etc/sysconfig/network
sudo sed -i '0,/localhost/{s/localhost/mobius.local.localdomain mobius.local localhost/}' /etc/hosts
sudo reboot
