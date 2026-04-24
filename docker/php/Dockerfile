FROM php:8.4-fpm-alpine

# Install system dependencies
RUN apk add --no-cache \
    $PHPIZE_DEPS \
    bash \
    git \
    mariadb-client \
    nodejs \
    npm \
    unzip \
    oniguruma-dev \
    libzip-dev \
    mariadb-dev \
    icu-dev \
    linux-headers

# PHP extensions
RUN docker-php-ext-install \
    pdo_mysql \
    mbstring \
    zip \
    bcmath \
    intl

# Copy PHP configuration
COPY docker/php/conf.d /usr/local/etc/php/conf.d

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
COPY docker/php/entrypoint.sh /usr/local/bin/laravel-entrypoint
RUN chmod +x /usr/local/bin/laravel-entrypoint

WORKDIR /var/www

CMD ["php-fpm"]
