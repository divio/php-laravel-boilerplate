#!/bin/bash

if [ ! -f /app/.env ]; then
    cp /app/.env.example /app/.env
    php /app/artisan key:generate
fi

if [ ! -f /app/vendor/autoload.php ]; then
    composer install
fi
