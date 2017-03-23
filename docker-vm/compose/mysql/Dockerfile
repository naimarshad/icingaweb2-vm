FROM centos:latest
MAINTAINER Naeem <naimarshad@gmail.com>

RUN yum -y update 
RUN yum -y install epel-release
RUN yum -y install https://packages.icinga.com/epel/7/release/noarch/icinga-rpm-release-7-1.el7.centos.noarch.rpm
RUN yum -y install vim hostname bind-utils cronie logrotate supervisor rsyslog sudo passwd which pwgen psmisc icinga2 nagios-plugins-all mariadb-server mariadb-libs mariadb net-tools iproute

# Adding initial script along with supervisord.conf
COPY ./init-container.sh /bin/init-container.sh
COPY ./supervisord.conf /etc/supervisord.conf

# Adding and fixing directories permissions
RUN chmod 755 /bin/init-container.sh
RUN mkdir -p /var/log/supervisor; \
 chown -R icinga:root /etc/icinga2; \
 mkdir -p /var/run/icinga2; \
 mkdir -p /var/log/icinga2; \
 chown icinga:icingacmd /var/run/icinga2; \
 chown icinga:icingacmd /var/log/icinga2; \
 mkdir -p /var/run/icinga2/cmd; \
 mkfifo /var/run/icinga2/cmd/icinga2.cmd; \
 chown -R icinga:icingacmd /var/run/icinga2/cmd; \
 chmod 2750 /var/run/icinga2/cmd; \
 chown -R icinga:icinga /var/lib/icinga2

EXPOSE 3306

CMD ["init-container.sh"]
