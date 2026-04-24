#!/usr/bin/env sh
set -e

cd /var/www

if [ "$#" -eq 0 ]; then
    set -- php-fpm
fi

if [ ! -f .env ] && [ -f .env.example ]; then
    echo "Creating .env from .env.example"
    cp .env.example .env
fi

if [ ! -d vendor ]; then
    echo "Installing Composer dependencies"
    composer install --no-interaction --prefer-dist
else
    echo "Composer dependencies already installed"
fi

if [ ! -d node_modules ]; then
    echo "Installing npm dependencies"
    npm install
else
    echo "npm dependencies already installed"
fi

if [ -f artisan ]; then
    if ! grep -Eq '^APP_KEY=.+$' .env 2>/dev/null && [ -z "${APP_KEY:-}" ]; then
        echo "Generating Laravel application key"
        php artisan key:generate --force
    else
        echo "Laravel application key already configured"
    fi

    DB_HOST="${DB_HOST:-db}"
    DB_PORT="${DB_PORT:-3306}"
    DB_USERNAME="${DB_USERNAME:-laravel}"
    DB_PASSWORD="${DB_PASSWORD:-secret}"

    echo "Waiting for MySQL at ${DB_HOST}:${DB_PORT}"
    until mariadb-admin ping -h"${DB_HOST}" -P"${DB_PORT}" -u"${DB_USERNAME}" -p"${DB_PASSWORD}" --ssl=0 --silent; do
        sleep 2
    done

    php artisan config:clear --ansi
    php artisan migrate --force --ansi
fi

exec "$@"
