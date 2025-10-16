FROM php:8.2 AS php

# Install dependencies
RUN apt-get update -y && apt-get install -y \
    unzip libpq-dev libcurl4-gnutls-dev libzip-dev zip git \
    && docker-php-ext-install pdo pdo_mysql bcmath

# Install Redis extension
RUN pecl install redis \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis

# Set working directory
WORKDIR /var/www

# Copy application files
COPY . .

# Copy Composer from official image
COPY --from=composer:2.3.5 /usr/bin/composer /usr/bin/composer


ENV PORT=8000
# Set entrypoint
ENTRYPOINT ["docker/entrypoint.sh"]


#========================================================================================================

#node
FROM node:14-alpine as node

WORKDIR /var/www

COPY . .

RUN npm install --global cross-env 
RUN npm install

VOLUME /var/www/node_modules
