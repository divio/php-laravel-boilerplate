FROM php:7.3.3-fpm-alpine3.9

RUN curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer

WORKDIR /app

EXPOSE 80/tcp 443/tcp
COPY . /app
