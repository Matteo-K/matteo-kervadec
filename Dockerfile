# Utilisation de l'image PHP officielle avec Apache
FROM php:8.2-apache

# Installer les extensions PHP requises
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev zip git unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql

# Installer Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Activer mod_rewrite
RUN a2enmod rewrite

# Copier les fichiers du projet
WORKDIR /var/www/html
COPY . .

# Copier la configuration Apache personnalisée
COPY apache/000-default.conf /etc/apache2/sites-available/000-default.conf

# Installer les dépendances PHP via Composer (obligatoire car /vendor/ est dans le .gitignore)
RUN composer install --no-dev --optimize-autoloader

# Définit le nom de domaine
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Créer le dossier var/ s'il n'existe pas (sinon chown plante)
RUN mkdir -p /var/www/html/var

# Définir les permissions
RUN chown -R www-data:www-data /var/www/html/var

# Exposer le port HTTP
EXPOSE 80

# Commande de démarrage
CMD ["apache2-foreground"]
