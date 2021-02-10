FROM php:7.4-cli-alpine
RUN docker-php-ext-install -j$(nproc) mysqli opcache
WORKDIR /var/www/html

# Install base packages
RUN apk update
RUN apk upgrade

# xdebug with VSCODE
RUN apk --no-cache add --virtual .build-deps \
  g++ \
  autoconf \
  make && \
  pecl install xdebug && docker-php-ext-enable xdebug && \
  apk del .build-deps && \
  rm -r /tmp/pear/*

RUN echo "[xdebug]" >> /usr/local/etc/php/php.ini && \
  echo "xdebug.mode=debug" >> /usr/local/etc/php/php.ini && \
  echo "xdebug.start_with_request = yes" >> /usr/local/etc/php/php.ini && \
  echo "xdebug.client_port = 9000" >> /usr/local/etc/php/php.ini && \
  echo 'xdebug.idekey = "VSCODE"' >> /usr/local/etc/php/php.ini

# Change TimeZone
RUN apk add --update tzdata
ENV TZ=Europe/Zurich
