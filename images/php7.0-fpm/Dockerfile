FROM phusion/baseimage:

MAINTAINER ivan@lagunovsky.com

ENV DEBIAN_FRONTEND noninteractive

ENV PHP_INI_DIR /etc/php/7.0/fpm/
ENV PHP_VERSION 7.0.2
ENV PHP_FILENAME php-7.0.2.tar.xz
ENV PHP_SHA256 556121271a34c442b48e3d7fa3d3bbb4413d91897abbb92aaeced4a7df5f2ab2
ENV PHP_USER www-data
ENV PHP_AUTOCONF /usr/bin/autoconf
ENV ENV_TYPE development

# persistent / runtime deps
RUN apt-get update && apt-get install -y ca-certificates wget librecode0 libmagickwand-dev libsasl2-dev libmemcached-dev imagemagick libsqlite3-0 libxml2 --no-install-recommends && rm -r /var/lib/apt/lists/*

# phpize deps
RUN apt-get update && apt-get install -y build-essential autoconf file g++ gcc libc-dev make pkg-config re2c --no-install-recommends && rm -r /var/lib/apt/lists/*

RUN mkdir -p $PHP_INI_DIR/conf.d \
    && mkdir -p $PHP_INI_DIR/pool.d

RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "1A4E8B7277C42E53DBA9C7B9BCAA30EA9C0D5763";

RUN buildDeps=" \
        libcurl4-openssl-dev \
        libreadline6-dev \
        librecode-dev \
        libzip-dev \
        libsqlite3-dev \
        libssl-dev \
        libxml2-dev \
        xz-utils \
        libicu-dev \
        libpcre3-dev \
        libbz2-dev \
        libpq-dev \
        libt1-dev \
        libjpeg8 \
        libpng12-dev \
        libfreetype6-dev \
        libmcrypt-dev \
        libgd2-xpm-dev \
        libgmp-dev \
        libmysqlclient-dev \
        curl \
    " \
    && set -x \
    && apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
    && curl -fSL "http://php.net/get/$PHP_FILENAME/from/this/mirror" -o "$PHP_FILENAME" \
    && echo "$PHP_SHA256 *$PHP_FILENAME" | sha256sum -c - \
    && curl -fSL "http://php.net/get/$PHP_FILENAME.asc/from/this/mirror" -o "$PHP_FILENAME.asc" \
    && gpg --verify "$PHP_FILENAME.asc" \
    && mkdir -p /usr/src/php \
    && tar -xf "$PHP_FILENAME" -C /usr/src/php --strip-components=1 \
    && rm "$PHP_FILENAME"*

RUN cd /usr/src/php && ./configure \
        --with-config-file-path="$PHP_INI_DIR" \
        --with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
        --disable-cgi \
        --enable-intl \
        --enable-pcntl \
        --enable-fpm \
        --enable-mbstring \
        --enable-force-cgi-redirect \
        --with-fpm-user=$PHP_USER \
        --with-fpm-group=$PHP_USER \
        --with-mcrypt=/usr \
        --with-pcre-regex \
        --enable-pdo \
        --with-openssl \
        --with-openssl-dir=/usr/bin \
        --with-sqlite3=/usr \
        --with-pdo-sqlite=/usr \
        --enable-inline-optimization \
        --with-icu-dir=/usr \
        --with-curl=/usr/bin \
        --with-bz2 \
        --enable-sockets \
        --with-mysqli=mysqlnd \
        --with-pdo-mysql=mysqlnd \
        --with-gd \
        --with-pear \
        --with-tsrm-pthreads \
        --with-jpeg-dir=/usr \
        --with-png-dir=/usr \
        --with-xpm-dir=/usr \
        --with-freetype-dir=/usr \
        --enable-gd-native-ttf \
        --with-mcrypt \
        --enable-exif \
        --with-gettext \
        --enable-bcmath \
        --with-openssl \
        --with-readline \
        --with-recode \
        --with-zlib \
    && make -j"$(nproc)" \
    && make install \
    && { find /usr/local/bin /usr/local/sbin -type f -executable -exec strip --strip-all '{}' + || true; }

COPY scripts/docker-php-ext-* /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-php-ext-*

ENV PHP_AMQP_BUILD_DEPS libtool automake git pkg-config librabbitmq-dev libzmq-dev

RUN apt-get update && apt-get install -y $PHP_AMQP_BUILD_DEPS --no-install-recommends && rm -r /var/lib/apt/lists/*

#Must be keep
RUN apt-get update && apt-get install -y libmagickwand-dev libvips-dev libgsf-1-dev libmagickcore-dev libevent-dev --no-install-recommends && rm -r /var/lib/apt/lists/*

# MONGO
RUN cd /etc && git clone --depth=1 -b 1.1.1 https://github.com/mongodb/mongo-php-driver.git \
    && cd /etc/mongo-php-driver \
    && git submodule update --init \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && touch $PHP_INI_DIR/conf.d/ext-mongodb.ini \
    && echo 'extension=mongodb.so' >> $PHP_INI_DIR/conf.d/ext-mongodb.ini

# REDIS
RUN cd /etc && git clone --depth=1 -b php7 https://github.com/phpredis/phpredis.git \
    && cd /etc/phpredis \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && touch $PHP_INI_DIR/conf.d/ext-redis.ini \
    && echo 'extension=redis.so' >> $PHP_INI_DIR/conf.d/ext-redis.ini

# MEMCACHED
RUN cd /etc && git clone --depth=1 -b php7 https://github.com/php-memcached-dev/php-memcached.git \
    && cd /etc/php-memcached \
    && phpize \
    && ./configure --disable-memcached-sasl \
    && make \
    && make install \
    && touch $PHP_INI_DIR/conf.d/ext-redis.ini \
    && echo 'extension=memcached.so' >> $PHP_INI_DIR/conf.d/ext-redis.ini

RUN docker-php-ext-install-pecl zip
RUN php -m | grep zip
RUN docker-php-ext-enable opcache

#CLEAN
RUN apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false $buildDeps $PHP_AMQP_BUILD_DEPS
RUN apt-get clean all
RUN rm -Rf /usr/lib/rabbitmq-c

# Create php.ini
RUN curl https://raw.githubusercontent.com/php/php-src/PHP-$PHP_VERSION/php.ini-$ENV_TYPE -o $PHP_INI_DIR/php.ini

ADD config/php-fpm.conf $PHP_INI_DIR/php-fpm.conf
ADD config/www.conf $PHP_INI_DIR/pool.d/www.conf

ADD scripts/php7.0-fpm /etc/init.d/php7.0-fpm
RUN chmod +x /etc/init.d/php7.0-fpm \
    && update-rc.d php7.0-fpm defaults

RUN ln -s /usr/local/sbin/php-fpm /usr/sbin/php-fpm7.0

ADD scripts/php7.0-fpm-checkconf /usr/lib/php/php7.0-fpm-checkconf
RUN chmod +x /usr/lib/php/php7.0-fpm-checkconf

ADD config/php7.0-fpm.service /lib/systemd/system/php7.0-fpm.service

RUN mkdir /run/php/

RUN curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

# forward request and error logs to docker log collector
RUN ln -sf /dev/stderr /var/log/php7.0-fpm.log

ADD start-php /etc/my_init.d/start-php.sh
RUN chmod +x /etc/my_init.d/start-php.sh

EXPOSE 9000
