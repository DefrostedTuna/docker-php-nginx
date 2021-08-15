# Docker PHP Nginx

## Description
This is a Docker container that runs PHP and Nginx in a single instance. Primarily intended for use with Laravel applications, the image is built on top of Alpine Linux and ties the two main processes together using Supervisor. In the event either process dies, Supervisor will detect this failure and kill the entire container.

To use with this container for a project, simply pull down the desired version.

```bash
# CLI
docker pull defrostedtuna/php-nginx:8.0
```

```Dockerfile
# Dockerfile
FROM defrostedtuna/php-nginx:8.0
```

```yaml
# docker-compose
version: '3.5'

services:
  app:
    image: defrostedtuna/php-nginx:8.0
    # Additional container configuration here...
```

Images will be versioned based on the PHP version used within the container. For example; 

* `defrostedtuna/php-nginx:7.3` -> PHP `7.3`
* `defrostedtuna/php-nginx:8.0` -> PHP `8.0`

## Packages

Packages installed via Alpine's native manager include the following;

* `curl`
* `nginx`
* `php`
* `php-bcmath`
* `php-ctype`
* `php-curl`
* `php-dom`
* `php-fileinfo`
* `php-fpm`
* `php-json`
* `php-mbstring`
* `php-opcache`
* `php-openssl`
* `php-pdo_mysql`
* `php-phar`
* `php-session`
* `php-simplexml`
* `php-tokenizer`
* `php-xml`
* `php-xmlwriter`
* `php-zip`
* `python3`
* `supervisor`
* `unzip`
* `zip`

Composer has also been bundled in so that PHP dependencies may be installed from within the Docker container. Installing these dependencies from within the context of the container will ensure that versions are consistent across environments. Composer's version is controlled via each Dockerfile as to ensure compatibility in the event Composer receives an update. This covers odd scenarios where pulling the most recent version of Composer may conflict with the installed packages or dependencies.

Dev dependencies such as `php-xdebug` and `php-sqlite` should be included in a development Dockerfile that extends this base image to keep the production Docker container free of unused items. Splitting dependencies this way allows for the segregation of resources for development environments, while still maintaining a relatively clean image for production. 

## Building Images

Images are built using GitHub Actions and are pushed to Docker Hub for public consumption. In the event it is desirable to build the images locally, the proper context and file must be specified. This is due to the nested structure of the repository.

A global set of configuration files are specified at the root of this project that should apply to each container that is built. The Dockerfiles for each container are stored in their own subdirectory so that specific configuration overrides may be stored alongside the corresponding container. Docker cannot reach out to the parent directory relative to the context that is set to retrieve these global configuration files, so the context and file must be specified independently.

```bash
# Set the context to the root of the project, while specifying the desired Dockerfile

docker build -t defrostedtuna/php-nginx:8.0 . -f php-8.0/Dockerfile
```

## Example Project Setup

An example application that utilizes this image could look like the following;

```
├── ...
├── dev.Dockerfile
├── docker-compose.yaml
├── Dockerfile
├── ...
```

The `dev.Dockerfile` would contain any additional dependencies required for testing or debugging.

```Dockerfile
FROM defrostedtuna/php-nginx:8.0

# Add sqlite and xdebug for development purposes.
RUN apk add --no-cache \
    php8-pdo_sqlite \
    php8-sqlite3 \
    php8-xdebug

# Enable the xdebug extension.
# `/etc/php` has been symlinked to `/etc/php{version}` on the parent container for ease of use.
RUN echo zend_extension=xdebug.so >> /etc/php/conf.d/xdebug.ini
```

This `dev.Dockerfile` would be used to bootstrap the application via a `docker-compose.yaml` file when developing on a local machine.

```yaml
version: '3.5'

services:
  app:
    build:
      context: .
      dockerfile: dev.Dockerfile
    container_name: app
    working_dir: /app
    volumes:
      - ./:/app # The application contents live within the `/app` directory in the Docker container.
    # Additional container configuration here...
```

Likewise, the production `Dockerfile` would be free to create the application in a way that is optimal for a production environment.

```Dockerfile
FROM defrostedtuna/php-nginx:8.0

# Copy the project files.
COPY . /app

# Install dependencies.
RUN composer install --no-dev --optimize-autoloader

# Set application permissions.
RUN chown -R www:www /app
RUN chmod -R ug+rwx /app/storage /app/bootstrap/cache
RUN chmod -R 774 /app/storage/logs
```