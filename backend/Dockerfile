FROM php:8.2-fpm-alpine

# Installation des dépendances système
RUN apk add --no-cache \
    curl \
    git \
    unzip \
    libzip-dev \
    oniguruma-dev \
    docker-cli \
    && docker-php-ext-install pdo pdo_mysql mysqli zip

# Installation de Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configuration PHP
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
    && echo "expose_php = Off" >> "$PHP_INI_DIR/php.ini" \
    && echo "display_errors = Off" >> "$PHP_INI_DIR/php.ini" \
    && echo "upload_max_filesize = 10M" >> "$PHP_INI_DIR/php.ini" \
    && echo "post_max_size = 10M" >> "$PHP_INI_DIR/php.ini"

WORKDIR /var/www/backend

# Copier les fichiers de dépendances
COPY composer.json composer.lock* ./

# Installer les dépendances PHP
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Copier le code source (sans écraser vendor)
COPY public ./public
COPY src ./src
COPY database ./database

# Permissions
RUN chown -R www-data:www-data /var/www/backend

# Exposer le port PHP-FPM
EXPOSE 9000

CMD ["php-fpm"]
