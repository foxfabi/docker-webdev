#!/usr/bin/env bash

#echo ' Starting PHP Server'
#/usr/local/bin/php -S 0.0.0.0:7409 -t /var/www/backend/public/ &

echo ' Starting PHP Swoole Server'
/usr/local/bin/php /var/www/backend/public/server.php &

# Run the given command or start defaults
if [ $# -gt 0 ];then
    # If we passed a command, run it
    # exec "$@"
    docker-php-entrypoint $@
else
    # Otherwise start PHP FastCGI Process Manager
    docker-php-entrypoint php-fpm
fi
