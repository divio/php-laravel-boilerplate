FROM divio/base-php

COPY database /app/database
COPY composer.* /app/
RUN cd /app && composer install --no-scripts

# COPY package*.json /
# RUN cd / && npm install

COPY . /app
RUN php /app/artisan package:discover --ansi
RUN php -r "file_exists('/app/.env') || copy('/app/.env.example', '/app/.env');"
RUN php /app/artisan key:generate --ansi

# TODO add to base image
# this snippet is required by Divio Cloud for compatibility
# https://github.com/divio/divio-cli/blob/master/divio_cli/localdev/main.py#L125
COPY migrate.sh /app/migrate.sh
COPY start.sh /usr/local/bin/start
RUN chmod +x /usr/local/bin/start
RUN curl -O https://bin.equinox.io/c/ekMN3bCZFUn/forego-stable-linux-amd64.tgz
RUN tar xf forego-stable-linux-amd64.tgz
RUN mv forego /usr/local/bin/forego

COPY apache.conf /etc/apache2/sites-enabled/000-default.conf

RUN chmod -r 777 /app/storage/framework

WORKDIR /app

EXPOSE 80

# RUN npm run prod --prefix /
