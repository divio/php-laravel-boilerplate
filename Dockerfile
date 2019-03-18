FROM divio/base-php

COPY database /var/www/html/database
COPY composer.* /var/www/html/
RUN cd /var/www/html && composer install --no-scripts

# COPY package*.json /
# RUN cd / && npm install

COPY . /var/www/html
RUN php /var/www/html/artisan package:discover --ansi
RUN php -r "file_exists('/var/www/html/.env') || copy('/var/www/html/.env.example', '/var/www/html/.env');"
RUN php /var/www/html/artisan key:generate --ansi

# TODO add to base image
# this snippet is required by Divio Cloud for compatibility
# https://github.com/divio/divio-cli/blob/master/divio_cli/localdev/main.py#L125
COPY migrate.sh /app/migrate.sh
COPY start.sh /usr/local/bin/start
RUN chmod +x /usr/local/bin/start
RUN curl -O https://bin.equinox.io/c/ekMN3bCZFUn/forego-stable-linux-amd64.tgz
RUN tar xf forego-stable-linux-amd64.tgz
RUN mv forego /usr/local/bin/forego


WORKDIR /var/www/html

EXPOSE 80

# RUN npm run prod --prefix /
