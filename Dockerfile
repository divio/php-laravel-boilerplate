FROM robwi/php-test:0.0.4

COPY src /app
RUN cd /app && composer install --no-scripts
RUN cd /app && yarn install
RUN yarn run prod 

COPY config/vhost.conf /etc/nginx/sites-available/default

WORKDIR /app

EXPOSE 80

RUN php /app/artisan package:discover --ansi

# prepare laravel environment
RUN php /app/artisan key:generate --ansi 

RUN mkdir -p bootstrap/cache storage storage/framework storage/framework/sessions storage/framework/views storage/framework/cache
RUN chmod -R 777 storage/framework

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod a+x /usr/local/bin/docker-entrypoint

CMD [ "/usr/local/bin/docker-entrypoint" ]
