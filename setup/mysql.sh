#!/bin/bash
cd $SETUP_HOME

cd /tmp

# add the offical repo first
wget http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm
sudo yum -y localinstall mysql-community-release-el6-5.noarch.rpm 

# install the server
sudo yum -y install mysql-community-server mysql-devel

# add a DB user 'delphix' with all grants and remote access permissions
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'delphix'@'%' IDENTIFIED BY 'delphix' WITH GRANT OPTION;"
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'delphix'@'localhost' IDENTIFIED BY 'delphix' WITH GRANT OPTION;"

# create an admin user for replication etc
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'delphix_admin'@'localhost' IDENTIFIED BY 'delphix' WITH GRANT OPTION;"
mysql -uroot -e "GRANT REPLICATION SLAVE ON *.* TO 'delphix_admin'@'localhost';"
mysql -uroot -e "GRANT SELECT, RELOAD, REPLICATION CLIENT, SHOW VIEW, EVENT, TRIGGER ON *.* TO 'delphix_admin'@'localhost';"

mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'delphix_admin'@'de.delphix.local' IDENTIFIED BY 'delphix' WITH GRANT OPTION;"
mysql -uroot -e "GRANT REPLICATION SLAVE ON *.* TO 'delphix_admin'@'de.delphix.local';"
mysql -uroot -e "GRANT SELECT, RELOAD, REPLICATION CLIENT, SHOW VIEW, EVENT, TRIGGER ON *.* TO 'delphix_admin'@'de.delphix.local';"

mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'delphix_admin'@'target.delphix.local' IDENTIFIED BY 'delphix' WITH GRANT OPTION;"
mysql -uroot -e "GRANT REPLICATION SLAVE ON *.* TO 'delphix_admin'@'target.delphix.local';"
mysql -uroot -e "GRANT SELECT, RELOAD, REPLICATION CLIENT, SHOW VIEW, EVENT, TRIGGER ON *.* TO 'delphix_admin'@'target.delphix.local';"

# write our own /etc/my.cnf
sudo rm /etc/my.cnf

sudo echo "[mysqld]" >> /etc/my.cnf
sudo echo "datadir=/var/lib/mysql" >> /etc/my.cnf
sudo echo "socket=/var/lib/mysql/mysql.sock" >> /etc/my.cnf
sudo echo "log-bin=mysql-bin" >> /etc/my.cnf
sudo echo "symbolic-links=0" >> /etc/my.cnf
sudo echo "sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES" >> /etc/my.cnf
sudo echo "server-id=1" >> /etc/my.cnf
sudo echo "" >> /etc/my.cnf
sudo echo "[mysqld_safe]" >> /etc/my.cnf
sudo echo "log-error=/var/log/mysqld.log" >> /etc/my.cnf
sudo echo "pid-file=/var/run/mysqld/mysqld.pid" >> /etc/my.cnf

# set the (db-)root password
#mysqladmin -u root password delphix

# enable automatic (re-)start
sudo chkconfig mysqld on
sudo service mysqld restart
