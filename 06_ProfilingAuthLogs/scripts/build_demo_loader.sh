wget -P /home/centos http://ftp.naz.com/apache/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz
cd ~
gunzip apache-maven-3.6.0-bin.tar.gz
tar xvf apache-maven-3.6.0-bin.tar.gz
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.201.b09-2.el7_6.x86_64
export PATH=/home/centos/apache-maven-3.6.0/bin:$PATH
git clone https://github.com/simonellistonball/metron-field-demos.git
cd metron-field-demos/auth/
mvn package
