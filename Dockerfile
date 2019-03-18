FROM php:7.3.3-fpm-alpine3.9

RUN apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        curl-dev \
        imagemagick-dev \
        libtool \
        libxml2-dev \
        postgresql-dev \
        sqlite-dev \
    && apk add --no-cache \
        curl \
        git \
        imagemagick \
        mysql-client \
        postgresql-libs \
        libintl \
        icu \
        icu-dev \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && docker-php-ext-install \
        curl \
        iconv \
        mbstring \
        pdo \
        pdo_mysql \
        pdo_pgsql \
        pdo_sqlite \
        pcntl \
        tokenizer \
        xml \
        intl \
    && curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer \
    && apk del -f .build-deps

COPY install-node.sh /
RUN sh /install-node.sh

COPY database /app/database
COPY composer.* /app/
RUN cd /app && composer install --no-scripts

COPY package*.json /
RUN cd / && npm install

COPY . /app
RUN php /app/artisan package:discover --ansi
RUN php -r "file_exists('/app/.env') || copy('/app/.env.example', '/app/.env');"
RUN php /app/artisan key:generate --ansi

WORKDIR /app

EXPOSE 80

RUN npm run prod --prefix /

CMD sh
