#!/bin/sh

# Optimize Laravel if the environemnt is not local.
# if [ -f "artisan" ] && [ ! -z "$APP_ENV" ] && [ "$APP_ENV" != "local" ]; then
#   php artisan config:cache
#   php artisan route:cache
# fi

# Run Supervisor which will start the applications.
/usr/bin/supervisord -c /etc/supervisord/supervisord.conf