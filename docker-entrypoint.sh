#!/bin/bash

# This is used to prepare the .env file for laravel test and live environments
# it translates the environment variables into a syntax that laravel can understand 

# change app settings
sed -i "s/APP_URL=.*/APP_URL=https:\/\/${DOMAIN:-localhost}/g" /app/.env
sed -i "s/APP_DEBUG=.*/APP_DEBUG=${DEBUG:-true}/g" /app/.env

# change db settings
DB_PROTOCOL="$(echo $DEFAULT_DATABASE_DSN | grep :// | sed -e's,^\(.*://\).*,\1,g')"
DB_URL="$(echo ${DEFAULT_DATABASE_DSN/$DB_PROTOCOL/})"
DB_AUTH="$(echo $DB_URL | grep @ | cut -d@ -f1)"
DB_USERNAME="${DB_AUTH%:*}"
DB_PASSWORD="$(echo $DB_AUTH | grep : | cut -d: -f2)"
DB_HOST="$(echo ${DB_URL/$DB_AUTH@/} | cut -d/ -f1)"
DB_PORT="$(echo $DB_HOST | sed -e 's,^.*:,:,g' -e 's,.*:\([0-9]*\).*,\1,g' -e 's,[^0-9],,g')"
DB_DATABASE="$(echo $DB_URL | grep / | cut -d/ -f2-)"

sed -i "s/DB_HOST=.*/DB_HOST=${DB_HOST/\:$DB_PORT/}/g" /app/.env
sed -i "s/DB_PORT=.*/DB_PORT=${DB_PORT:-5432}/g" /app/.env
sed -i "s/DB_DATABASE=.*/DB_DATABASE=${DB_DATABASE:-db}/g" /app/.env
sed -i "s/DB_USERNAME=.*/DB_USERNAME=${DB_USERNAME:-postgres}/g" /app/.env
sed -i "s/DB_PASSWORD=.*/DB_PASSWORD=${DB_PASSWORD}/g" /app/.env

# force set drivers
sed -i "s/CACHE_DRIVER=.*/DB_DATABASE=database/g" /app/.env
sed -i "s/SESSION_DRIVER=.*/DB_USERNAME=database/g" /app/.env

# set AWS credentials 
if [ -n "$DEFAULT_STORAGE_DSN" ]; then 

    AWS_PROTOCOL="$(echo $DEFAULT_STORAGE_DSN | grep :// | sed -e's,^\(.*://\).*,\1,g')"
    AWS_URL="$(echo ${DEFAULT_STORAGE_DSN/$AWS_PROTOCOL/})"
    AWS_AUTH="$(echo $AWS_URL | grep @ | cut -d@ -f1)"
    AWS_USERNAME="${AWS_AUTH%:*}"
    AWS_PASSWORD="$(echo $AWS_AUTH | grep : | cut -d: -f2)"
    AWS_HOST="$(echo ${AWS_URL/$AWS_AUTH@/} | cut -d/ -f1)"

    sed -i "s/FILESYSTEM_DRIVER=.*/FILESYSTEM_DRIVER=s3/g" /app/.env
    sed -i "s/AWS_ACCESS_KEY_ID=.*/AWS_ACCESS_KEY_ID=$AWS_USERNAME/g" /app/.env
    sed -i "s/AWS_SECRET_ACCESS_KEY=.*/AWS_SECRET_ACCESS_KEY=$AWS_PASSWORD/g" /app/.env
    sed -i "s/AWS_BUCKET=.*/AWS_BUCKET=$AWS_HOST/g" /app/.env

fi

# run database migrations
php /app/artisan migrate

/usr/bin/dumb-init php-fpm7.2 -D && nginx
