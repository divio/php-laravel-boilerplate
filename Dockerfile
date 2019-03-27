FROM robwi/php-test:latest

COPY src /code
RUN cd /code && composer install --no-scripts
RUN cd /code && yarn install
RUN yarn run prod 

# COPY apache.conf /etc/apache2/sites-enabled/000-default.conf
COPY config/vhost.conf /etc/nginx/sites-available/default

WORKDIR /code

EXPOSE 80

RUN php /code/artisan package:discover --ansi

# RUN php -r "file_exists('/code/.env') || copy('/code/.env.example', '/code/.env');"
RUN cp /code/.env.example /code/.env

# prepare laravel environment
RUN php /code/artisan key:generate --ansi && \
    php /code/artisan cache:table && \
    php /code/artisan session:table

RUN mkdir -p bootstrap/cache storage storage/framework storage/framework/sessions storage/framework/views storage/framework/cache
RUN chmod -R 777 storage/framework

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod a+x /usr/local/bin/docker-entrypoint
ENTRYPOINT [ "/bin/bash" ]
CMD [ "/usr/local/bin/docker-entrypoint" ]