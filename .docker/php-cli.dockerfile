FROM php:7.4-cli-buster
RUN docker-php-ext-install -j$(nproc) mysqli opcache
WORKDIR /var/www/html

# PHP Code Sniffer
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

# XDebug
RUN echo "[xdebug]" >> $PHP_INI_DIR/php.ini && \
  echo "xdebug.mode=debug" >> $PHP_INI_DIR/php.ini && \
  echo "xdebug.start_with_request = yes" >> $PHP_INI_DIR/php.ini && \
  echo "xdebug.client_port = 9000" >> $PHP_INI_DIR/php.ini && \
  echo 'xdebug.idekey = "VSCODE"' >> $PHP_INI_DIR/php.ini

RUN echo "date.timezone=Europe/Zurich" >> $PHP_INI_DIR/php.ini