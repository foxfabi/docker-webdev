FROM php:7.4-cli
RUN docker-php-ext-install -j$(nproc) mysqli opcache
WORKDIR /var/www/html
