# Docker PHP Nginx

## Description
This is a Docker container that runs PHP and Nginx in a single instance. Primarily intended for use with Laravel applications, the image is built on top of Alpine Linux and ties the two main processes together using Supervisor. In the event either process dies, Supervisor will detect this failure and kill the entire container.

## Usage

Images are versioned based on the PHP version used within the container. For example; 

* `defrostedtuna/php-nginx:7.3` -> PHP `7.3`
* `defrostedtuna/php-nginx:8.0` -> PHP `8.0`

To use with this container for a project, simply pull down the desired version and configure it to your needs.

```bash
# CLI
docker pull defrostedtuna/php-nginx:8.0

docker run -it -v $(pwd):/app defrostedtuna/php-nginx:8.0
```

```Dockerfile
# Dockerfile
FROM defrostedtuna/php-nginx:8.0

# Copy the project files.
COPY . /app

# Install dependencies.
RUN composer install --no-dev --optimize-autoloader

# Set application permissions.
RUN chown -R www:www /app
RUN chmod -R ug+rwx /app/storage /app/bootstrap/cache
RUN chmod -R 774 /app/storage/logs

# Additional container configuration here...
```

```yaml
# docker-compose
version: '3.5'

services:
  app:
    image: defrostedtuna/php-nginx:8.0
    container_name: app
    working_dir: /app
    volumes:
      - ./:/app # The application lives within the '/app' directory in the Docker container.

    # Additional container configuration here...
```

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

**Composer** has also been bundled in so that PHP dependencies may be installed from within the Docker container. Installing these dependencies from within the context of the container will ensure that versions are consistent across environments. Composer's version is controlled via each dockerfile as to ensure compatibility in the event Composer receives an update. This covers odd scenarios where pulling the most recent version of Composer may conflict with the installed packages or dependencies.

## Development Dockerfile

Dev dependencies such as `php-xdebug` and `php-sqlite` have been _excluded_ from the main container in order to keep the production Docker container lean and free of unused items. Splitting dependencies this way allows for the segregation of resources for development environments while still maintaining a relatively clean image for production.

With this being the case, development containers exist alongside each main release and include a base set of dependencies useful for developing with Docker locally. Extra dependencies bundled with the development container include;

* `php-sqlite`
* `php-pdo_sqlite`
* `php-xdebug`

The development Docker container is configured to automatically enable `xdebug` for use with code coverage drivers. 

Development containers can be used by simply appending the `-dev` suffix to the end of the desired image version. For example; 

* `defrostedtuna/php-nginx:7.3-dev`
* `defrostedtuna/php-nginx:8.0-dev`

```bash
# CLI
docker pull defrostedtuna/php-nginx:8.0-dev

docker run -it -v $(pwd):/app defrostedtuna/php-nginx:8.0-dev
```

```Dockerfile
# Dockerfile
FROM defrostedtuna/php-nginx:8.0-dev

# Copy the project files.
COPY . /app

# Install dependencies (optional for development).
RUN composer install

# Set application permissions.
RUN chown -R www:www /app
RUN chmod -R ug+rwx /app/storage /app/bootstrap/cache
RUN chmod -R 774 /app/storage/logs

# Additional container configuration here...
```

```yaml
# docker-compose
version: '3.5'

services:
  app:
    image: defrostedtuna/php-nginx:8.0-dev
    container_name: app
    working_dir: /app
    volumes:
      - ./:/app # The application lives within the '/app' directory in the Docker container.

    # Additional container configuration here...
```

## Building Images

Images are built using GitHub Actions and are pushed to Docker Hub for public consumption. In the event it is desirable to build the images locally, the proper context and file must be specified. This is due to the nested structure of the repository.

A global set of configuration files are specified at the root of the repository that should apply to each container that is built. The dockerfiles for each container are stored in their own subdirectory so that specific configuration overrides may be stored alongside the corresponding container. Docker cannot reach out to the parent directory relative to the context that is set to retrieve these global configuration files, so the context and file must be specified explicitly.

```bash
# Set the context to the root of the project, while specifying the desired Dockerfile

docker build -t defrostedtuna/php-nginx:8.0 . -f php-8.0/Dockerfile

# Development Dockerfile
docker build -t defrostedtuna/php-nginx:8.0-dev . -f php-8.0/dev.Dockerfile
```