CREATE USER 'hive'@'%' IDENTIFIED BY 'admin';
GRANT all on *.* to 'hive'@localhost identified by 'admin';
flush privileges;
