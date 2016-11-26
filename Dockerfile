FROM php:7-fpm

RUN apt-get update && apt-get install -y zlib1g-dev libicu-dev g++ libmcrypt-dev libpq-dev libldb-dev libldap2-dev phpunit git
RUN ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/libldap.so \
    && ln -s /usr/lib/x86_64-linux-gnu/liblber.so /usr/lib/liblber.so
RUN docker-php-ext-configure intl pdo_pgsql ldap zip mbstring mcrypt
RUN docker-php-ext-install intl pdo_pgsql ldap zip mbstring mcrypt

ADD conf/30-custom.ini /usr/local/etc/php/conf.d/30-custom.ini

RUN curl --silent --show-error https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer