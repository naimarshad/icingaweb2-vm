# Installation packages & instructions to run icinga2 monitoring solution server
This repo contains the instructions of vanilla CentOS 7 minimal installation to host docker containers & as well as to build VMs for icingaweb2 monitoring solution.

Inside docker-vm folder we have a compose folder which contains the docker-compose.yml file to use the Dockerfiles to build the  respective containers. It also contains the instructions to create a macvlan interface in-case some one wants to use physical router as gateway and user similar network ranges.

The Dockerfile contains to build container for below services;

 1- MariaDB
 2- Apache Server
 2- SSH Daemon
 3- Icinga2 Daemon
 4- Supervisor Daemon
 
 Dockerfile also includes the instructions to add extra files for supervisord & initaliazing the container on run.
