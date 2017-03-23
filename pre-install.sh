#!/bin/bash

#Installing icinga2 Repos, updating repo cache & installing latest packages
echo "Installing icinga2 Repos, updating repo cache & installing latest packages"
echo "######################################################################################################"
 yum -y install policycoreutils-python vim epel-release; yum clean all
 yum -y install http://packages.icinga.com/epel/7/release/noarch/icinga-rpm-release-7-1.el7.centos.noarch.rpm; yum clean all
 yum -y update; yum clean all; \


#Installing the required packages for icinga2 daemon (Apache, mariadb php etc.)
echo "Installing the required packages for icinga2 daemon (Apache, mariadb php etc.)"
echo "######################################################################################################"
yum -y install rsyslog httpd nagios-plugins-all mariadb-server mariadb-libs mariadb icinga2 icinga2-doc icinga2-ido-mysql icingaweb2 icingacli php-ZendFramework php-ZendFramework-Db-Adapter-Pdo-Pgsql php-ZendFramework-Db-Adapter-Pdo-Mysql php-ldap

yum clean all;


#Enable the icinga2 features & the apache users to the proper groups
echo "Enable the icinga2 features & the apache users to the proper groups"
echo "######################################################################################################"
icinga2 feature enable ido-mysql command
usermod -a -G icingacmd apache
usermod -a -G icingaweb2 apache

#Installing & configuring the mysql database server
echo " Installing & configuring the mysql database server"
echo "######################################################################################################"
mysql_install_db
chown -R mysql:mysql /var/lib/mysql/
/usr/bin/mysqld_safe &
sleep 10


#creating database, users & assinging permissions for icinga2 monitoring schema and for the icinga web 2 schema
echo "Creating database, users & assinging permissions for icinga2 monitoring schema and for the icinga web 2 schema"
echo "######################################################################################################"
mysqladmin -u root password rootsrv007
mysql -uroot -prootsrv007 -e "CREATE DATABASE icinga2"
mysql -uroot -prootsrv007 -e "GRANT ALL PRIVILEGES ON icinga2.* TO 'icinga2'@'localhost' IDENTIFIED BY 'IcingaPass'; FLUSH PRIVILEGES;"
mysql -uroot -prootsrv007 icinga2 < /usr/share/icinga2-ido-mysql/schema/mysql.sql
mysql -uroot -prootsrv007 -e "CREATE DATABASE IF NOT EXISTS icingaweb2 ; GRANT ALL ON icingaweb2.* TO icingaweb2@localhost IDENTIFIED BY 'icingaweb2';"
mysql -uicingaweb2 -picingaweb2 icingaweb2 < /usr/share/doc/icingaweb2/schema/mysql.schema.sql
mysql -uicingaweb2 -picingaweb2 icingaweb2 -e "INSERT INTO icingaweb_user (name, active, password_hash) VALUES ('webadmin', 1, '\$1\$y.0MLecb\$JbJUsaeoLnc8U3kUW1tiS1');"

#Cofiguring the timezone in php.ini file
echo" Cofiguring the timezone in php.ini file"
echo "######################################################################################################"
sed -i 's/;date.timezone =/date.timezone = Asia\/Riyadh/g' /etc/php.ini

pkill mysqld
chown -R mysql:mysql /var/lib/mysql/

#Adding ports to open for connection to the running services for apache, rsyslog & icinga2
echo "Adding ports to open for connection to the running services for apache, rsyslog & icinga2"
echo "######################################################################################################"
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --add-port=514/tcp
firewall-cmd --permanent --add-port=4665/tcp
firewall-cmd --reload

#setting selinux contexts to let /etc/icingaweb2 directory for read & write permissons by http process
echo "Setting selinux contexts to let /etc/icingaweb2 directory for read & write permissons by http process"
echo "######################################################################################################"
semanage fcontext -a -t httpd_sys_rw_content_t "/etc/icingaweb2(/.*)?"
restorecon -R -v /etc/icingaweb2


#Enbaling the services at boot & making sure they are started
echo "Enbaling the services at boot & making sure they are started"
echo "######################################################################################################"
systemctl enable maraidb; systemctl restart mariadb
systemctl enable icinga2; systemctl restart icinga2
systemctl enable httpd; systemctl restart httpd
