# Utilisation de l'image PHP officielle avec Apache
FROM php:8.2-apache

# Installer les extensions PHP requises
RUN apt-get update && apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev zip git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql

# Installer Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Configuration Apache
COPY ./apache/000-default.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

# Copier le code de ton projet
COPY . /var/www/html/

# Définir les permissions appropriées pour le répertoire
RUN chown -R www-data:www-data /var/www/html/var /var/www/html/vendor

# Installer les dépendances avec Composer
WORKDIR /var/www/html
RUN composer install --no-dev --optimize-autoloader

# Exposer le port 80
EXPOSE 80
