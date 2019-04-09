FROM robwi/divio-php:7.3-stretch
EXPOSE 80

COPY migrate.sh run-locally.sh Procfile divio-cloud-init.php divio-migrate.sh /app/
COPY start.sh /usr/local/bin/start

RUN chmod a+x /usr/local/bin/start /app/migrate.sh /app/run-locally.sh /app/divio-migrate.sh

COPY composer.* /app/
RUN cd /app && composer install --no-scripts --no-autoloader

COPY package.json /app/
RUN cd /app/ && yarn install

COPY config/vhost.conf /etc/nginx/sites-available/default
COPY run-locally.sh /run-locally.sh

WORKDIR /app
COPY . /app

RUN cp /app/.env.example /app/.env \
    && composer dump-autoload \
    && php artisan key:generate \
    && php artisan package:discover

RUN echo 'auto_prepend_file="/app/divio-cloud-init.php"' > /usr/local/etc/php/conf.d/divio-conf.ini

RUN mkdir -p bootstrap/cache storage storage/framework storage/framework/sessions storage/framework/views storage/framework/cache && chmod -R 777 storage/framework
RUN yarn run prod
