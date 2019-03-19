FROM divio/base-php:0.0.2

COPY database /app/database
COPY composer.* /app/
RUN cd /app && composer install --no-scripts

COPY package.json /
COPY yarn.lock /
RUN cd / && yarn install

COPY apache.conf /etc/apache2/sites-enabled/000-default.conf

WORKDIR /app

EXPOSE 80

COPY . /app
RUN php /app/artisan package:discover --ansi
RUN php -r "file_exists('/app/.env') || copy('/app/.env.example', '/app/.env');"
RUN php /app/artisan key:generate --ansi
RUN chmod -R 777 /app/storage/framework

RUN yarn run prod --prefix /
