# Sử dụng PHP + Apache
FROM php:8.1-apache

# Cài extension PHP cần thiết cho Laravel
RUN apt-get update && apt-get install -y \
    git unzip libzip-dev libpng-dev libonig-dev libxml2-dev zip curl libcurl4-openssl-dev \
    && docker-php-ext-install pdo_mysql mbstring zip exif pcntl bcmath gd xml curl

# Cài Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy toàn bộ source code vào container
COPY . .

# Set quyền thư mục storage và bootstrap/cache
RUN chmod -R 777 storage bootstrap/cache

# Cài Laravel dependencies
RUN composer install --no-dev --optimize-autoloader

# Expose port 80
EXPOSE 80

# Start Apache khi container khởi chạy
CMD ["apache2-foreground"]
