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
mysql -uroot -prootsrv007 icinga2 < /usr/share/icinga2-ido-mysql/schema/mysql.sql
mysql -uroot -prootsrv007 -e "CREATE DATABASE IF NOT EXISTS icingaweb2 ; GRANT ALL ON icingaweb2.* TO icingaweb2@localhost IDENTIFIED BY 'icingaweb2';"
mysql -uicingaweb2 -picingaweb2 icingaweb2 < /usr/share/doc/icingaweb2/schema/mysql.schema.sql
mysql -uicingaweb2 -picingaweb2 icingaweb2 -e "INSERT INTO icingaweb_user (name, active, password_hash) VALUES ('webadmin', 1, '\$1\$y.0MLecb\$JbJUsaeoLnc8U3kUW1tiS1');"
sed -i 's/;date.timezone =/date.timezone = UTC/g' /etc/php.ini




pkill mysqld
chown -R mysql:mysql /var/lib/mysql/

systemctl enable maraidb && systemctl start mariadb

firewall-cmd --permanent --add-ports=80/tcp
firewall-cmd --permanent --add-ports=4665/tcp
firewall-cmd --reload

semanage fcontext -a -t httpd_sys_rw_content_t "/etc/icingaweb2(/.*)?"
restorecon -R -v /etc/icingaweb2

