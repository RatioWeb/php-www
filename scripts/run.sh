#!/bin/bash


# Disable PHP modules
modules=();
IFS=' ' read -a modules <<< ${PHP_DISABLE_MODULES}
for i in ${modules[@]};do
    php5dismod $i;
done

# Generate root password (if it has sense)
if [ ! -d "/var/spool/php-www" ]
then

    echo "Generating root password"
    PASSWORD=`apg -n1 -c /dev/random`;
    echo "****************************"
    echo "*                          *"
    echo "* root password: $PASSWORD *"
    echo "*                          *"
    echo "****************************"
    mkdir -p /var/spool/php-www
    touch /var/spool/php-www/password-generated
    echo "root:$PASSWORD" | chpasswd

    echo "Generating www-data password"
    PASSWORD=`apg -n1 -c /dev/random`;
    echo "****************************"
    echo "*                          *"
    echo "* www-data password: $PASSWORD *"
    echo "*                          *"
    echo "****************************"
    mkdir -p /var/spool/php-www
    touch /var/spool/php-www/password-generated
    echo "www-data:$PASSWORD" | chpasswd
fi


sed -ri -e "s/^upload_max_filesize.*/upload_max_filesize = ${PHP_UPLOAD_MAX_FILESIZE}/" \
    -e "s/^post_max_size.*/post_max_size = ${PHP_POST_MAX_SIZE}/" /etc/php5/apache2/php.ini

exec supervisord -n
