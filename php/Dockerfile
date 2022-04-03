ARG PHP_VERSION=8.1

FROM php:${PHP_VERSION}-cli-alpine

ENV \
    # Fix for iconv: https://github.com/docker-library/php/issues/240
    LD_PRELOAD="/usr/lib/preloadable_libiconv.so php" \
    PATH="${PATH}:/home/warp/app/vendor/bin" \
    XDEBUG_MODE="off"

COPY --from=composer:2 /usr/bin/composer /usr/local/bin/
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

RUN apk add --update \
        bash \
        less \
        git \
        gnu-libiconv \
    && install-php-extensions bcmath intl opcache zip xdebug pcntl uuid

ARG UID=1000
ARG GID=1000

RUN addgroup -g $GID warp \
    && adduser -D -S -h /home/warp -s /bin/bash -G warp -u $UID warp \
    && mkdir -p /home/warp/app \
    && echo "PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '" > /home/warp/.bashrc \
    && chown -R warp:warp /home/warp

WORKDIR /home/warp/app
USER warp
