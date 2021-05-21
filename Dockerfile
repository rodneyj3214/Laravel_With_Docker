FROM php:7.4-fpm-alpine

ARG user
ARG uid

RUN set -ex \
  && apk --no-cache add \
    postgresql-dev libzip-dev zlib-dev libpng-dev npm nodejs bash openssl libxml2-dev php-soap
#RUN apk add build-base zlib-dev libpng-dev zip zlib-dev libzip-dev

RUN apk add libpng libpng-dev libjpeg-turbo-dev libwebp-dev zlib-dev libxpm-dev gd && docker-php-ext-install gd

RUN docker-php-ext-configure gd 

RUN docker-php-ext-install pdo bcmath pdo_pgsql gd zip
RUN chown -R www-data:www-data /var/www

# Get latest Composer
COPY --from=composer:2.0.12 /usr/bin/composer /usr/bin/composer

RUN set -x ; \
  addgroup -g $uid -S $user ; \
  adduser -u $uid -D -S -G $user $user && exit 0 ; exit 1

USER $user