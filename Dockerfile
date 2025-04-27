FROM php:8.1-apache

# Install PHP extensions
RUN apt-get update && apt-get install -y \
    git unzip libpng-dev libjpeg-dev libfreetype6-dev libzip-dev libicu-dev zlib1g-dev g++ \
    libonig-dev libxslt1-dev libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql intl zip xsl

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy source
COPY . .

# Copy env file
RUN cp .env.example .env

# Install Laravel dependencies
RUN composer install --no-dev --optimize-autoloader
RUN npm install
RUN npm run prod

# Fix permissions
RUN chmod -R 777 storage bootstrap/cache

# Expose port
EXPOSE 80
