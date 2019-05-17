FROM robwi/divio-php:7.3-stretch
EXPOSE 80

COPY migrate.sh Procfile /app/
COPY divio/*.php divio/*.sh /app/divio/
COPY start.sh /usr/local/bin/start

RUN echo '[www]\nclear_env = no' > /usr/local/etc/php-fpm.d/zz-divio.conf
RUN echo 'auto_prepend_file="/app/divio/rewrite-env.php"' > /usr/local/etc/php/conf.d/divio-conf.ini
RUN chmod a+x /usr/local/bin/start /app/*.sh

COPY composer.* /app/
# We are running composer install BEFORE copying your application
# into the container to cache layers when requirements are not
# changing. This behaviour could break your process if you run
# composer post-install commands that rely on the existence of your
# code.
# If that is the case, you could either move the install command
# below the COPY instruction or uncomment and adjust the composer
# run-script below
RUN cd /app && composer install --no-scripts --no-autoloader

COPY package.* /app/
RUN cd /app && yarn install

COPY divio/nginx/vhost.conf /etc/nginx/sites-available/default

WORKDIR /app
COPY . /app

# RUN cd /app && composer run-script post-install-cmd

RUN cp /app/.env.example /app/.env \
    && composer dump-autoload \
    && php artisan key:generate \
    && php artisan package:discover

RUN mkdir -p bootstrap/cache storage storage/framework storage/framework/sessions storage/framework/views storage/framework/cache && chmod -R 777 storage/framework
RUN yarn run prod

ENTRYPOINT [ "" ]
CMD ["start", "web"]
