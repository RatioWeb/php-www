FROM ubuntu:trusty
MAINTAINER Jarek Sobiecki <jsobiecki@baddrop.com>

# Install packages (this is generic version with all required extensions).
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
  apt-get -y install supervisor git apache2 libapache2-mod-php5 mysql-server php5-mysql pwgen php-apc php5-mcrypt php5-curl php5-xhprof php5-xdebug php5-memcache php5-gd

# Configure open ssh
# See: http://docs.docker.com/examples/running_ssh_service/ for more details
RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile


# Add image configuration and scripts
ADD scripts/start-apache2.sh /start-apache2.sh
ADD scripts/run.sh /run.sh
RUN chmod 755 /*.sh
ADD configs/php/php.ini /etc/php5/apache2/conf.d/40_custom.ini
ADD configs/supervisord/supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf
ADD configs/supervisord/supervisord-sshd.conf /etc/supervisor/conf.d/supervisord-sshd.conf

# config to enable .htaccess
ADD configs/apache/apache_default /etc/apache2/sites-available/000-default.conf
ADD configs/apache/apache_default_ssl /etc/apache2/sites-available/000-default-ssl.conf
RUN a2enmod rewrite
RUN a2enmod ssl


#Enviornment variables to configure php
ENV PHP_UPLOAD_MAX_FILESIZE 10M
ENV PHP_POST_MAX_SIZE 10M

EXPOSE 80 22

# Add volumes for Apache 
VOLUME  ["/var/log/apache2" ]

CMD ["/run.sh"]
