# Bước 1: Base image PHP + Apache
FROM php:8.1-apache

# Bước 2: Cài extension PHP
RUN apt-get update && apt-get install -y \
    git unzip libpng-dev libjpeg-dev libfreetype6-dev libzip-dev libicu-dev zlib1g-dev g++ \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql zip

# Bước 3: Cài composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Bước 4: Copy toàn bộ source vào container
WORKDIR /var/www/html
COPY . .

# Bước 5: Copy env mẫu
RUN cp .env.example .env

# Bước 6: Install Laravel dependencies
RUN composer install --no-dev --optimize-autoloader
RUN npm install
RUN npm run prod

# Bước 7: Fix quyền cho storage
RUN chmod -R 777 storage bootstrap/cache

# Bước 8: Expose port
EXPOSE 80
