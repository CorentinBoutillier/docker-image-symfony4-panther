
FROM php:latest

RUN apt-get update && apt-get install -y libzip-dev zlib1g-dev libicu-dev g++ chromium chromium-driver && docker-php-ext-install zip json pdo pdo_mysql \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl
ENV PANTHER_NO_SANDBOX 1
ENV PANTHER_CHROME_DRIVER_BINARY /usr/bin/chromedriver

RUN apt-get -y install zip unzip
RUN apt-get install -y -qq git 

# ⚡️ Symfony
RUN apt search wget
RUN apt-get install wget -y
RUN wget https://get.symfony.com/cli/installer -O - | bash
RUN mv /root/.symfony/bin/symfony /usr/local/bin/symfony

# ⚡️ Xdebug
RUN yes | pecl install xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini


COPY php.ini /usr/local/etc/php/
COPY . /var/www/html/

# ⚡️ Composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer && \
    chmod +x /usr/local/bin/composer && \
    composer self-update --preview

# ⚡️ Node.js
RUN curl -sL https://deb.nodesource.com/setup_10.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install nodejs -y
RUN npm install npm@6.4.0 -g

# ⚡️ Yarn
RUN npm install -g yarn

RUN symfony -V
