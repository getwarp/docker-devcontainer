ARG PHP_VERSION=8.2
FROM php:${PHP_VERSION}-cli-alpine AS php_base

ENV \
    # Fix for iconv: https://github.com/docker-library/php/issues/240
    LD_PRELOAD="/usr/lib/preloadable_libiconv.so php" \
    PATH="${PATH}:/home/warp/app/vendor/bin" \
    XDEBUG_MODE="off"

RUN apk add --update \
        bash \
        less \
        git \
        gnu-libiconv

ARG UID=1000
ARG GID=1000

RUN addgroup -g $GID warp \
    && adduser -D -S -h /home/warp -s /bin/bash -G warp -u $UID warp \
    && mkdir -p /home/warp/app \
    && echo "PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '" > /home/warp/.bashrc \
    && chown -R warp:warp /home/warp

# https://github.com/mlocati/docker-php-extension-installer#supported-php-extensions
COPY --from=mlocati/php-extension-installer:1.5 /usr/bin/install-php-extensions /usr/bin/
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/

FROM php_base AS php7

RUN install-php-extensions \
        bcmath-stable \
        intl-stable \
        opcache-stable \
        pcntl-stable \
        uuid-stable \
        xdebug-3.1.6 \
        zip-stable

WORKDIR /home/warp/app
USER warp

FROM php_base AS php8

RUN install-php-extensions \
        bcmath-stable \
        intl-stable \
        opcache-stable \
        pcntl-stable \
        uuid-stable \
        xdebug-^3.2.0 \
        zip-stable

WORKDIR /home/warp/app
USER warp
