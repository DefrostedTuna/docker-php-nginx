#!/bin/sh

curl -sS https://getcomposer.org/installer -o composer-setup.php
EXPECTED_SIGNATURE="$(curl -sS https://composer.github.io/installer.sig)"
ACTUAL_SIGNATURE="$(php -r "echo hash_file('SHA384', 'composer-setup.php');")"

if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]; then
  >&2 echo 'Error: Composer signatures do not match!'
  rm composer-setup.php
  exit 1
fi

php composer-setup.php \
  --quiet \
  --install-dir=/usr/sbin \
  --filename=composer \
  --version=$1

EXIT_CODE=$?
rm composer-setup.php
exit $EXIT_CODE