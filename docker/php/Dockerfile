FROM ubuntu:20.04

ARG USER_ID=1001
ARG GROUP_ID=1001

RUN usermod -u ${USER_ID} www-data
RUN groupmod -g ${GROUP_ID} www-data

# Install apache, PHP, and supplimentary programs. openssh-server, curl, and lynx-cur are for debugging the container.
RUN apt-get update \
    &&  apt-get install -y software-properties-common \
    && add-apt-repository ppa:ondrej/php \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install apache2 php8.0 php8.0-mysql libapache2-mod-php8.0 php8.0-mbstring php8.0-xml php8.0-gd php8.0-zip unzip php8.0-redis curl lynx ffmpeg nodejs npm

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN npm install -g npm@7.20.6
RUN npm install -g node@14.17

#RUN npm install -g npm@next

# Enable apache mods.
RUN a2enmod php8.0
RUN a2enmod rewrite
RUN a2enmod remoteip

RUN echo 'RemoteIPHeader X-Forwarded-For' > /etc/apache2/conf-available/remoteip.conf && a2enconf remoteip

# Update the PHP.ini file, enable <? ?> tags and quieten logging.
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php/8.0/apache2/php.ini
RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php/8.0/apache2/php.ini
RUN echo "display_errors = On" >> /etc/php/8.0/apache2/php.ini
RUN echo "upload_max_filesize = 200M" >> /etc/php/8.0/apache2/php.ini
RUN echo "post_max_size = 200M" >> /etc/php/8.0/apache2/php.ini
RUN echo "memory_limit = 500M" >> /etc/php/8.0/apache2/php.ini
RUN echo "max_execution_time = 600" >> /etc/php/8.0/apache2/php.ini

# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

EXPOSE 80

ENV APACHE_DOCUMENT_ROOT /var/www/html/public

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
RUN sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

#RUN useradd -m -u 1001 -s /bin/bash klaus
#RUN chown -R klaus:www-data /var/www/html

RUN chown -R www-data:www-data /var/www/html

RUN mkdir -p /var/www/.npm \
    && chown -Rv www-data:www-data /var/www/.npm

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php8.0-curl

WORKDIR /var/www/html

CMD /usr/sbin/apache2ctl -D FOREGROUND
