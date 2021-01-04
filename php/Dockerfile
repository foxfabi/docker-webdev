FROM php:7.4-fpm-alpine
RUN docker-php-ext-install -j$(nproc) mysqli opcache
# Use the default production configuration
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
