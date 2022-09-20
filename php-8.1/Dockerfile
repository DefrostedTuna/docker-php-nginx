FROM alpine:3.16
LABEL Maintainer="Rick Bennett <rbennett1106@gmail.com>"

# Essentials
RUN echo "UTC" > /etc/timezone
RUN apk add --no-cache zip unzip curl python3 supervisor

# PHP Configuration (8.1.9-r0)
RUN apk add --no-cache \
    php81 \
    php81-bcmath \
    php81-ctype \
    php81-curl \
    php81-dom \
    php81-fileinfo \
    php81-fpm \
    php81-json \
    php81-mbstring \
    php81-opcache \
    php81-openssl \
    php81-pdo_mysql \
    php81-phar \
    php81-session \
    php81-simplexml \
    php81-tokenizer \
    php81-xml \
    php81-xmlwriter \
    php81-zip

# Nginx Configuration (1.22.0-r1)
RUN apk add --no-cache nginx

# Setup the user and group permissions
RUN adduser -D -g 'www' www

# Link php81 to php
RUN ln -sf php81 /usr/bin/php && \
    ln -sf /usr/sbin/php-fpm81 /usr/bin/php-fpm && \
    ln -sf /etc/php81 /etc/php && \
    ln -sf /usr/bin/python3 /usr/bin/python

# Bootstrap directories
RUN mkdir -p /app && \
    mkdir -p /var/tmp/nginx && \
    mkdir -p /var/tmp/nginx/client_body && \
    mkdir -p /var/log/supervisord

# Bootstrap files
RUN touch /var/run/php-fpm.pid && \
    touch /var/run/nginx.pid && \
    touch /var/run/supervisord.pid

# Copy configs (PHP)
COPY configs/php/php.ini /etc/php/php.ini
COPY configs/php/php-fpm.conf /etc/php/php-fpm.conf
COPY configs/php/php-fpm.d/www.conf /etc/php/php-fpm.d/www.conf

# Copy configs (Nginx)
COPY configs/nginx/nginx.conf /etc/nginx/nginx.conf
COPY configs/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

# Copy configs (Supervisor)
COPY configs/supervisord/supervisord.conf /etc/supervisord/supervisord.conf

# Copy scripts
COPY scripts/install_composer.sh /root

# Copy entrypoint script
COPY scripts/entrypoint.sh /sbin/entrypoint.sh

# Change ownership
RUN chown -R www:www /app && \
    chown -R www:www /var/run/php-fpm.pid && \
    chown -R www:www /var/run/nginx.pid && \
    chown -R www:www /var/run/supervisord.pid && \
    chown -R www:www /var/lib/nginx && \
    chown -R www:www /var/tmp/nginx && \
    chown -R www:www /var/log/supervisord

# Change permissions
RUN chmod -R 755 /root/install_composer.sh && \
    chmod -R 770 /var/tmp/nginx && \
    chmod -R 770 /var/tmp/nginx/client_body && \
    chmod -R 755 /sbin/entrypoint.sh

# Install Composer
ENV PATH="/root/.composer/vendor/bin:${PATH}"
RUN cd /root && ./install_composer.sh 2.4.1

WORKDIR /app

EXPOSE 80
CMD ["/sbin/entrypoint.sh"]