FROM divio/base-php

COPY database /app/database
COPY composer.* /app/
RUN cd /app && composer install --no-scripts

COPY package*.json /
RUN cd / && npm install

COPY . /app
RUN php /app/artisan package:discover --ansi
RUN php -r "file_exists('/app/.env') || copy('/app/.env.example', '/app/.env');"
RUN php /app/artisan key:generate --ansi

WORKDIR /app

EXPOSE 80

RUN npm run prod --prefix /

CMD ["php", "artisan", "serve", "--port=80", "--host=0.0.0.0"]
