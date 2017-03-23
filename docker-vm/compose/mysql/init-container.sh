#!/bin/bash

mkdir /dbdata
rm -rf /var/lib/mysql
ln -s /dbdata /var/lib/mysql
chown -R mysql:mysql /dbdata*

mysql_install_db
chown -R mysql:mysql /var/lib/mysql/
/usr/bin/mysqld_safe &
sleep 10


echo "Configuring mysql and creating initial db"
mysqladmin -u root password rootpass
mysql -uroot -prootpass -e "CREATE USER 'myuser'@'localhost' IDENTIFIED BY 'easypass';"
mysql -uroot -prootpass -e "CREATE DATABASE mydb"
mysql -uroot -prootpass -e "GRANT ALL PRIVILEGES ON mydb.* TO 'myuser'@'localhost' IDENTIFIED BY 'easypass'; FLUSH PRIVILEGES;"
mysql -uroot -prootpass -e "GRANT ALL PRIVILEGES ON *.* TO 'myuser'@'localhost' IDENTIFIED BY 'easypass' WITH GRANT OPTION; FLUSH PRIVILEGES;"
mysql -uroot -prootpass -e "GRANT ALL PRIVILEGES ON *.* TO 'myuser'@'%' IDENTIFIED BY 'easypass' WITH GRANT OPTION; FLUSH PRIVILEGES;"
mysql -uroot -prootpass -e "select user, host FROM mysql.user;"


#echo "Configuring mysql and creating initial db"
#mysqladmin -u root password rootpass
#mysql -uroot -prootpass -e "CREATE USER 'tesdb'@'localhost' IDENTIFIED BY 'easypass';"
#mysql -uroot -prootpass -e "CREATE DATABASE testdb"
#mysql -uroot -prootpass -e "GRANT ALL PRIVILEGES ON testdb.* TO 'testdb'@'localhost' IDENTIFIED BY 'easypass'; FLUSH PRIVILEGES;"
#mysql -uroot -prootpass -e "GRANT ALL PRIVILEGES ON *.* TO 'testdb'@'%' IDENTIFIED BY 'easypass' WITH GRANT OPTION; FLUSH PRIVILEGES;"
#mysql -uroot -prootpass -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'rootpass' WITH GRANT OPTION; FLUSH PRIVILEGES;"
#mysql -uroot -prootpass -e "select user, host FROM mysql.user;"

pkill mysqld
chown -R mysql:mysql /var/lib/mysql/

/usr/bin/supervisord -c /etc/supervisord.conf


