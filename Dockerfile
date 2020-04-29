FROM divio/base:0.3-php7.3-stretch
EXPOSE 80

COPY migrate.sh Procfile /app/
COPY divio/*.php divio/*.sh /app/divio/
COPY start.sh /usr/local/bin/start

RUN echo '[www]\nclear_env = no' > /usr/local/etc/php-fpm.d/zz-divio.conf
RUN echo 'auto_prepend_file="/app/divio/rewrite-env.php"' > /usr/local/etc/php/conf.d/divio-conf.ini
RUN chmod a+x /usr/local/bin/start /app/*.sh

ENV NODE_VERSION=14 \
    NPM_VERSION=6.14.4
RUN bash -c "source $NVM_DIR/nvm.sh && \
    nvm install $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    nvm use default && \
    npm install -g npm@$NPM_VERSION && \
    npm cache clear --force"
ENV NODE_PATH=$NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules \
    PATH=$NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN mkdir -p bootstrap/cache storage storage/framework storage/framework/sessions storage/framework/views storage/framework/cache && chmod -R 777 storage/framework

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
RUN bash -c "source $NVM_DIR/nvm.sh && cd /app && npm install"

COPY divio/nginx/vhost.conf /etc/nginx/sites-available/default

WORKDIR /app
COPY . /app

# RUN cd /app && composer run-script post-install-cmd

RUN bash -c "cp /app/.env.example /app/.env \
    && composer dump-autoload \
    && php artisan key:generate \
    && php artisan package:discover"

RUN bash -c "source $NVM_DIR/nvm.sh && npm run prod"

ENTRYPOINT [ "" ]
CMD ["start", "web"]
