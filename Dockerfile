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

WORKDIR /var/www/html

EXPOSE 80

# RUN npm run prod --prefix /
