FROM php:8.2-apache

# Installer les dépendances
RUN apt-get update && apt-get install -y \
    git unzip libicu-dev libonig-dev libzip-dev zip libpq-dev \
    && docker-php-ext-install intl pdo pdo_mysql zip opcache

# Installer Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copier les fichiers de l'app
COPY . /var/www/html/

# Déplacer dans le bon dossier
WORKDIR /var/www/html/

# Installer les dépendances PHP
RUN composer install --no-dev --optimize-autoloader

# Activer le mod_rewrite pour Apache
RUN a2enmod rewrite

# Config Apache pour Symfony (URL rewriting)
COPY .docker/vhost.conf /etc/apache2/sites-available/000-default.conf
