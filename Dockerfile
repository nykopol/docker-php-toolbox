FROM php:7.1-fpm

RUN apt-get update && apt-get install -y zlib1g-dev libicu-dev g++ libmcrypt-dev libpq-dev libldb-dev libldap2-dev git libfreetype6-dev libjpeg62-turbo-dev libpng-dev rabbitmq-server librabbitmq-dev
RUN ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/libldap.so \
    && ln -s /usr/lib/x86_64-linux-gnu/liblber.so /usr/lib/liblber.so
RUN docker-php-ext-configure intl \
    && docker-php-ext-install intl pdo_pgsql ldap zip mbstring mcrypt

RUN docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

ADD conf/30-custom.ini /usr/local/etc/php/conf.d/30-custom.ini

RUN curl --silent --show-error https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

RUN curl --silent --show-error -L -o phpunit.phar https://phar.phpunit.de/phpunit.phar \
    && mv phpunit.phar /usr/local/bin/phpunit

RUN curl -L http://cs.sensiolabs.org/download/php-cs-fixer-v2.phar -o php-cs-fixer \
    && chmod a+x php-cs-fixer \
    && mv php-cs-fixer /usr/local/bin/php-cs-fixer

RUN pecl install amqp
RUN docker-php-ext-enable amqp
