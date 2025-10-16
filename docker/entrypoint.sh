#!/bin/bash
set -e

# Install composer dependencies if not already installed
if [ ! -d "vendor" ]; then
    echo "Installing composer dependencies..."
    composer install --no-progress --no-interaction
fi

# Create .env file if it doesn't exist
if [ ! -f ".env" ]; then
    echo "Creating env file for env $APP_ENV"
    cp .env.example .env
else
    echo ".env file already exists."
fi

role=${CONTAINER_ROLE:-app}

if [ "$role" = "app" ]; then
    echo "Starting Laravel application..."
    php artisan key:generate --force
    php artisan migrate --force
    php artisan cache:clear
    php artisan config:clear
    php artisan route:clear
    php artisan serve --port=${PORT:-8000} --host=0.0.0.0 --env=.env
    exec docker-php-entrypoint "$@"
elif [ "$role" = "queue" ]; then
    echo "Running the queue worker..."
    php /var/www/artisan queue:work --verbose --tries=3 --timeout=180

elif [ "$role" = "websocket" ]; then
    echo "Running the websocket server..."
    php artisan websockets:serve
else
    echo "Unknown container role: $role"
fi
