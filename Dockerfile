FROM wordpress:php7.0-apache


ENV NVM_DIR=/usr/local/nvm
ENV NODE_VERSION=20.15.0
ENV APACHE_DOCUMENT_ROOT=/var/www/html

COPY cert_custom.pem /usr/local/share/ca-certificates/cert_custom.crt

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y git vim unzip curl default-mysql-client && \
    update-ca-certificates

ENV NODE_PATH=$NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH=$NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN pecl install xdebug-3.1.5 \
    && docker-php-ext-enable xdebug \
    && { \
    echo 'xdebug.client_host=host.docker.internal'; \
    echo 'xdebug.client_port=9003'; \
    echo 'xdebug.mode=debug'; \
    echo 'xdebug.start_with_request=yes'; \
    echo 'xdebug.profiler_enable = 0'; \
    } >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
#echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20220829/xdebug.so" >> /usr/local/etc/php/conf.d/99-xdebug.ini && \
#echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/99-xdebug.ini && \
## echo "xdebug.idekey=docker" >> /usr/local/etc/php/conf.d/99-xdebug.ini && \
##echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/99-xdebug.ini && \
##echo "xdebug.log=/dev/stdout" > /usr/local/etc/php/conf.d/99-xdebug.ini && \
## echo "xdebug.log_level=0" > /usr/local/etc/php/conf.d/99-xdebug.ini && \

## --------------------------

COPY --from=composer /usr/bin/composer /usr/bin/composer

COPY --from=wordpress:cli /usr/local/bin/wp /usr/bin/wp

COPY --from=node /usr/local/bin/node /usr/bin/node


# Docker mounts all volumes as root (moby/moby#2259) but we'll be running as UID 33. As a workaround,
# we're going to create all mount points ahead of time.
#
# ! Make sure the list of folders matches volumes in `docker-compose-test.yml`.
RUN set -ex; \
    for f in /var/www /var/www/.wp-cli /var/opt/versionpress/logs; \
    do \
    mkdir -p "$f"; \
    chown -R 33:33 "$f"; \
    done

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
# Set the final runtime user
USER www-data