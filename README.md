# Description
This is generic www server (LAMP) used in our organisation for different PHP based projects. 

# What is included
- Apache + PHP 5.6
- SSH server
- Composer
- Drush (latest stable version)

# Usage 
Check compose/docker-compose.yml for example of working dev environement.

Basically, behavior of image can be slightly changed by using fe:vsplw magic ENV variables:
- **PHP_UPLOAD_MAX_FILESIZE** - change php.ini settings for bigger files
- **PHP_POST_MAX_SIZE** - maximum upload size
- **PHP_DISABLE_MODULES** - list (space separated) of disabled PHP modules. You might want to use it if you want to disable xdebug or xhprof

# SSH support
If you want to use bundled ssh server, please check container logs. It will include
auto generated root password.


# Volume settings
Basically only /var/log/apache2 and /var/www are configured as volumes. It means, that
after recreation of container, only files in those subdirectories will be preserved. 


