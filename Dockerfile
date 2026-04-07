# Use the official PHP image with Apache
FROM php:8.3-apache

# Update package lists
RUN apt-get update && \
    apt-get install -y \
    libcurl4-openssl-dev

RUN docker-php-ext-install pdo pdo_mysql

# Set PHP configurations
RUN echo "max_execution_time = 5000" >> /usr/local/etc/php/php.ini \
    && echo "max_input_time = 5000" >> /usr/local/etc/php/php.ini \
    && echo "memory_limit = 2048M" >> /usr/local/etc/php/php.ini

# Enable Apache modules
RUN a2enmod rewrite
RUN a2enmod ssl
RUN a2enmod headers

COPY vhosts.conf /etc/apache2/sites-available/000-default.conf
# Set working directory
WORKDIR /var/www/html

# Copy application files
#RUN chown -R www-data:www-data .
#COPY ./www .

# Expose port 80
EXPOSE 80

# Start Apache server
CMD ["apache2-foreground"]