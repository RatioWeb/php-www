#!/bin/bash

IFS=' ' read -a modules <<< ${PHP_DISABLE_MODULES}
for i in $(modules);do
    php5dismod $i;
done

sed -ri -e "s/^upload_max_filesize.*/upload_max_filesize = ${PHP_UPLOAD_MAX_FILESIZE}/" \
    -e "s/^post_max_size.*/post_max_size = ${PHP_POST_MAX_SIZE}/" /etc/php5/apache2/php.ini

exec supervisord -n
