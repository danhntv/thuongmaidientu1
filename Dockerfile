# Sử dụng PHP 8.1 + Apache image chính thức
FROM php:8.1-apache

# Cài các extension PHP cần thiết
RUN apt-get update && apt-get install -y \
    git unzip libpng-dev libjpeg-dev libfreetype6-dev zip libzip-dev libicu-dev zlib1g-dev g++ \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql zip intl

# Cài Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Làm việc trong /var/www/html
WORKDIR /var/www/html

# Copy toàn bộ source code vào container
COPY . .

# Install Laravel dependencies
RUN composer install --no-dev --optimize-autoloader
RUN npm install
RUN npm run prod

# Set quyền cho storage/bootstrap/cache
RUN chmod -R 777 storage bootstrap/cache

# Expose port 80
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
