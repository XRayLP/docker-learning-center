FROM ubuntu

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y tzdata ENV TZ "Europe/Berlin"
RUN echo "Europe/Berlin" > /etc/timezone \ && dpkg-reconfigure --frontend noninteractive tzdata
RUN apt-get install -y git curl apache2 php libapache2-mod-php php-mysql php-xml php-zip php-gd php-curl php-tidy

RUN apt-get install -y vim nano
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer
RUN chmod +x /usr/local/bin/composer

RUN rm -f /etc/localtime
RUN ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime
RUN rm -rf /var/www/html/*
  ADD src /var/www/html/

COPY /learning-center/* /var/www/html/

# Composer Install
RUN cd /var/www/html && composer install

RUN a2enmod rewrite
RUN chown -R www-data:www-data /var/www/html/
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

EXPOSE 80
COPY run.sh /run.sh
RUN chmod a+rx /run.sh
CMD ["/bin/bash", "/run.sh"]
