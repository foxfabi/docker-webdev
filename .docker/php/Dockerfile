# start with the official Composer image and name it
FROM composer:1.9.3 AS composer
ENV COMPOSER_ALLOW_SUPERUSER 1

FROM php:7.4-fpm-buster AS base
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV LC_ALL C.UTF-8
#RUN pwd && ls -la
RUN apt-get update &&           \
    apt-get install -y          \
    ca-certificates             \
    libcurl4-openssl-dev        \
    libssl-dev                  \
    supervisor                  \
    unzip                       \
    zlib1g-dev                  \
    curl                        \
    wget                        \
    default-mysql-client        \
    libmcrypt-dev               \
    libicu-dev                  \
    libpq-dev                   \
    libjpeg62-turbo-dev         \
    libjpeg-dev                 \
    libpng-dev                  \
    zlib1g-dev                  \
    libonig-dev                 \
    libxml2-dev                 \
    libzip-dev                  \
    unzip                       \
    --no-install-recommends &&  \
    apt-get clean &&            \
    rm -rf /var/lib/apt/lists/*
RUN docker-php-ext-install -j$(nproc)   \
    gd                                  \
    intl                                \
    mbstring                            \
    mysqli                              \
    zip                                 \
    curl                                \
    opcache                             \
    bcmath                              \
    sockets
# Add the async backend
ENV SWOOLE_URL=https://github.com/swoole/swoole-src/archive/v4.6.6.tar.gz
RUN docker-php-source extract &&        \
    mkdir /usr/src/php/ext/swoole &&    \
    curl -sfL $SWOOLE_URL -o swoole.tar.gz && \
    tar xfz swoole.tar.gz --strip-components=1 -C /usr/src/php/ext/swoole && \
    docker-php-ext-configure swoole \
    --enable-http2 --enable-mysqlnd --enable-openssl \
    --enable-sockets --enable-swoole-curl --enable-swoole-json && \
    docker-php-ext-install -j$(nproc) swoole && \
    rm -f swoole.tar.gz $HOME/.composer/*-old.phar && \
    docker-php-source delete && \
    rm -rf /var/lib/apt/lists/* $HOME/.composer/*-old.phar /usr/bin/qemu-*-static
# copy the Composer PHAR from the Composer image into the PHP image
COPY --from=composer /usr/bin/composer /usr/bin/composer
WORKDIR /var/www/backend
# from compose args
ARG VOLUME
ENV VOLUME $VOLUME
RUN echo $VOLUME
COPY $$VOLUME .
# COPY ./.docker/php/docker-entrypoint.sh /usr/bin/start-container
# RUN chmod +x /usr/bin/start-container
RUN composer install \
    --no-interaction \
    --no-scripts \
    --profile
# Smoke test
RUN echo "PHP Version:" "$(php -v)"
RUN echo "Composer Version:" "$(composer --version)"
EXPOSE 9000

FROM base as development
ADD https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar /usr/local/bin/phpcs
RUN chmod 755 /usr/local/bin/phpcs
ADD https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar /usr/local/bin/phpcbf
RUN chmod 755 /usr/local/bin/phpcbf
RUN phpcs --config-set show_progress 1 && \
    phpcs --config-set colors 1  && \
    phpcs --config-set default_standard PSR12  && \
    phpcs --config-set severity 1  && \
    phpcs --config-set report_width 120
# PHPDocumentor
ADD http://www.phpdoc.org/phpDocumentor.phar /usr/local/bin/phpdoc
RUN chmod 755 /usr/local/bin/phpdoc
# PHPUnit
ADD https://phar.phpunit.de/phpunit-6.5.phar /usr/local/bin/phpunit
RUN chmod 755 /usr/local/bin/phpunit
# Install sendmail package
RUN apt-get update && apt-get install -y msmtp msmtp-mta mailutils
# PHP configuration
RUN docker-php-source extract && \
    cp '/usr/src/php/php.ini-development' $PHP_INI_DIR/php.ini && \
    echo "date.timezone=${TZ}" >> $PHP_INI_DIR/conf.d/timezone.ini && \
    # XDEBUG PHP Config
    echo "[xdebug]" >> $PHP_INI_DIR/conf.d/xdebug.ini && \
    echo "xdebug.mode=debug" >> $PHP_INI_DIR/conf.d/xdebug.ini && \
    echo "xdebug.start_with_request = yes" >> $PHP_INI_DIR/conf.d/xdebug.ini && \
    echo "xdebug.client_port = 9000" >> $PHP_INI_DIR/conf.d/xdebug.ini && \
    echo 'xdebug.idekey = "VSCODE"' >> $PHP_INI_DIR/conf.d/xdebug.ini && \
    # Sendmail Config
    echo "[sendmail]" >> $PHP_INI_DIR/conf.d/sendmail.ini && \
    echo "smtp_server=${SMTP_SERVER}" >> $PHP_INI_DIR/conf.d/sendmail.ini && \
    echo "smtp_port=${SMTP_PORT}" >> $PHP_INI_DIR/conf.d/sendmail.ini && \
    #echo "sendmail_path=sendmail -i -t" >> $PHP_INI_DIR/conf.d/sendmail.ini && \
    echo "sendmail_path = \"/usr/bin/msmtp -C /etc/msmtprc -t\"" >> $PHP_INI_DIR/conf.d/sendmail.ini && \
    # Log Config
    echo "log_errors = On" >> $PHP_INI_DIR/conf.d/log.ini && \
    echo "error_log=/dev/stderr" >> $PHP_INI_DIR/conf.d/log.ini && \
    docker-php-source delete
# ENTRYPOINT ["php-fpm"]
# CMD [ "/usr/local/bin/php", "-S", "0.0.0.0:7409", "-t", "/var/www/backend/public/"]
#EXPOSE 7409
#CMD ["/usr/local/bin/php", "/var/www/backend/public/server.php"]
ENTRYPOINT ["start-container"]

# Build the backend
FROM base AS builder
# ENV COMPOSER_ALLOW_SUPERUSER 1
# PHP Compose
# RUN curl -sfL https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer && \
#     chmod +x /usr/bin/composer                                                                     && \
#     composer self-update 2.0.12
RUN composer install \
    --no-dev \
    --no-interaction \
    --no-scripts \
    --optimize-autoloader \
    --prefer-dist \
    --profile

#FROM php:7.4.7-cli-alpine3.12 as production
FROM builder AS production
WORKDIR /var/www/backend
COPY ./src/backend .
# you may want the php-fpm image
# I serve my applications with Swoole and nginx reverse proxy(10 times better performance this way)
# So I use the php-cli image.
COPY --from=builder /usr/local/lib/php/extensions /usr/local/lib/php/extensions
# PHP configuration
RUN docker-php-source extract && \
    cp '/usr/src/php/php.ini-production' $PHP_INI_DIR/php.ini && \
    echo "date.timezone=${TZ}" >> $PHP_INI_DIR/conf.d/timezone.ini && \
    echo "log_errors = On" >> $PHP_INI_DIR/conf.d/log.ini && \
    echo "error_log=/dev/stderr" >> $PHP_INI_DIR/conf.d/log.ini && \
    docker-php-source delete
# You may remove extensions that you don't need from here.
# RUN apk add --no-cache docker-php-ext-enable gd msgpack bcmath gd gmp sockets swoole
#HEALTHCHECK CMD curl --fail http://localhost:9501/ || exit 1
# EXPOSE 9501
# ENTRYPOINT ["php-fpm"]
# CMD [ "/usr/local/bin/php", "-S", "0.0.0.0:7409", "-t", "/var/www/backend/public/"]
#EXPOSE 7409
#CMD ["/usr/local/bin/php", "/var/www/backend/public/server.php"] # swoole
# ENTRYPOINT ["start-container"]
