FROM ubuntu:trusty
MAINTAINER Jarek Sobiecki <jsobiecki@ratioweb.pl>

# Install packages (this is generic version with all required extensions).
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
  apt-get -y install supervisor git apache2 libapache2-mod-php5 mysql-server php5-mysql pwgen php-apc php5-mcrypt php5-curl php5-xhprof php5-xdebug php5-memcache php5-gd drush



# Add image configuration and scripts
ADD scripts/start-apache2.sh /start-apache2.sh
ADD scripts/run.sh /run.sh
RUN chmod 755 /*.sh
ADD configs/php/php.ini /etc/php5/apache2/conf.d/40_custom.ini
ADD configs/supervisor/supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf

# config to enable .htaccess
ADD configs/apache/apache_default /etc/apache2/sites-available/000-default.conf
ADD configs/apache/apache_default_ssl /etc/apache2/sites-available/000-default-ssl.conf
RUN a2enmod rewrite
RUN a2enmod ssl


#Enviornment variables to configure php
ENV PHP_UPLOAD_MAX_FILESIZE 10M
ENV PHP_POST_MAX_SIZE 10M

EXPOSE 80

# Add volumes for Apache 
VOLUME  ["/var/log/apache2" ]

CMD ["/run.sh"]
