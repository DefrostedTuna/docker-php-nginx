FROM defrostedtuna/php-nginx:7.3

# Add sqlite and xdebug for development purposes.
RUN apk add --no-cache \
  php7-pdo_sqlite \
  php7-sqlite3 \
  php7-xdebug

# Increase the PHP memory limit for development.
RUN echo $'\nmemory_limit = 1G' >> /etc/php/php.ini 

# Enable the xdebug extension.
# `/etc/php` has been symlinked to `/etc/php{version}` on the parent container for ease of use.
RUN echo zend_extension=xdebug.so >> /etc/php/conf.d/xdebug.ini
ENV XDEBUG_MODE=coverage