#!/bin/bash

 yum -y update; yum clean all; \
 yum -y install policycoreutils-python vim epel-release; yum clean all
 yum -y install http://packages.icinga.com/epel/7/release/noarch/icinga-rpm-release-7-1.el7.centos.noarch.rpm; yum clean all

yum -y install rsyslog httpd nagios-plugins-all mariadb-server mariadb-libs mariadb icinga2 icinga2-doc icinga2-ido-mysql icingaweb2 icingacli php-ZendFramework php-ZendFramework-Db-Adapter-Pdo-Pgsql php-ZendFramework-Db-Adapter-Pdo-Mysql php-ldap

yum clean all;


icinga2 feature enable ido-mysql command
usermod -a -G icingacmd apache
usermod -a -G icingaweb2 apache

mysql_install_db
chown -R mysql:mysql /var/lib/mysql/
/usr/bin/mysqld_safe &
sleep 10

echo "Configuring mysql and creating initial db"
mysqladmin -u root password rootsrv007
mysql -uroot -prootsrv007 -e "CREATE DATABASE icinga2"
mysql -uroot -prootsrv007 -e "GRANT ALL PRIVILEGES ON icinga2.* TO 'icinga2'@'localhost' IDENTIFIED BY 'IcingaPass'; FLUSH PRIVILEGES;"
mysql -uroot -prootsrv007 -e "GRANT ALL PRIVILEGES ON *.* TO 'icinga2'@'%' IDENTIFIED BY 'IcingaPass' WITH GRANT OPTION; FLUSH PRIVILEGES;"
mysql -uroot -prootsrv007 -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'rootsrv007' WITH GRANT OPTION; FLUSH PRIVILEGES;"
mysql -uroot -prootsrv007 -e "select user, host FROM mysql.user;"

pkill mysqld
chown -R mysql:mysql /var/lib/mysql/

systemctl enable maraidb && systemctl start mariadb

firewall-cmd --permanent --add-service=http
firewall-cmd --reload

semanage fcontext -a -t httpd_sys_rw_content_t "/etc/icingaweb2(/.*)?"
restorecon -R -v /etc/icingaweb2

