#!/bin/bash
. $(dirname "$0")/ensure-env.sh
php /app/artisan serve --host 0.0.0.0 --port=80
