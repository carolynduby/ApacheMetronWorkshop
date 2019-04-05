# install the python packages required by python model
sudo yum -y install python-pip
sudo pip install pandas 
sudo pip install sklearn 
sudo pip install spicy
sudo pip install tldextract
sudo pip install spicy
sudo pip install Flask
sudo pip install bumpy

# create the root user in hdfs
sudo -u hdfs hdfs dfs -mkdir /user/root
sudo -u hdfs hdfs dfs -chown root /user/root
sudo -u hdfs hdfs dfs -ls /user/

# install the model in the root home directory
sudo cp -r ../dga_model/ /root/

# move the start script to home
cp ./start_dga_model.sh /home/centos
