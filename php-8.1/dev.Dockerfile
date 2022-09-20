FROM defrostedtuna/php-nginx:8.1

# Add sqlite and xdebug for development purposes.
RUN apk add --no-cache \
  php81-pdo_sqlite \
  php81-sqlite3 \
  php81-xdebug

# Enable the xdebug extension.
# `/etc/php` has been symlinked to `/etc/php{version}` on the parent container for ease of use.
RUN echo zend_extension=xdebug.so >> /etc/php/conf.d/xdebug.ini
ENV XDEBUG_MODE=coverage