#!/usr/bin/env bash

echo ' Starting PHP Server on port $PHPDEV_PORT'
/usr/local/bin/php -S 0.0.0.0:$PHPDEV_PORT -t /var/www/backend/public/ &

echo ' Starting PHP Swoole Server on port $API_PORT'
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
