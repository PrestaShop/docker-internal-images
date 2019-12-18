FROM prestashop/prestashop:nightly-7.2-apache

MAINTAINER Thomas Nabord <thomas.nabord@prestashop.com>

ENV GET_USER ""
ENV GET_FILE_MODULE ""
ENV ID_MODULE 0

ENV PS_HANDLE_DYNAMIC_DOMAIN 0
ENV PS_INSTALL_AUTO 1
ENV PS_DEV_MODE 1
ENV PS_COUNTRY fr
# Allow some builds (CI for instance) to not install all languages
ARG INSTALL_LANGUAGES=1
ENV PS_ALL_LANGUAGES ${INSTALL_LANGUAGES}
ENV PS_FOLDER_ADMIN admin-dev
ENV PS_FOLDER_INSTALL install-dev
ENV DB_SERVER localhost
ENV DB_USER macfly
ENV PS_ENABLE_SSL 1

# MySQL installation
# Avoid MySQL questions during installation
ENV DEBIAN_FRONTEND noninteractive
RUN echo mysql-server-5.6 mysql-server/root_password password $DB_PASSWD | debconf-set-selections
RUN echo mysql-server-5.6 mysql-server/root_password_again password $DB_PASSWD | debconf-set-selections
RUN apt update \
  && apt install -y default-mysql-server \
  && rm -rf /var/lib/apt/lists/*
# MySQL configuration
RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf
EXPOSE 3306

# SSL configuration
RUN a2enmod ssl
RUN ln -s $APACHE_CONFDIR/sites-available/default-ssl.conf $APACHE_CONFDIR/sites-enabled/default-ssl.conf
RUN apt update \
  && apt install -y ssl-cert \
  && rm -rf /var/lib/apt/lists/*
EXPOSE 443

RUN echo '[mysql.server]\nservice-startup-timeout = -1' >> /etc/mysql/conf.d/startup.cnf
RUN service mysql start \
&& mysql -e "CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWD'; GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'localhost'; FLUSH PRIVILEGES;" mysql \
	&& mysqladmin -h $DB_SERVER -P $DB_PORT -u $DB_USER -p$DB_PASSWD create $DB_NAME --force

COPY config_files/build/my-minimal.cnf /etc/mysql/conf.d/my-minimal.cnf
COPY config_files/docker-customization_run.sh /tmp/docker-customization_run.sh
COPY config_files/get-module.sh /tmp/get-module.sh
COPY config_files/update-domain.php /tmp/update-domain.php
RUN chmod u+x /tmp/docker-customization_run.sh /tmp/get-module.sh

RUN sed -ie "s/post_max_size\ =\ 20M/post_max_size\ =\ 40M/g" /usr/local/etc/php/php.ini
RUN sed -ie "s/upload_max_filesize\ =\ 20M/upload_max_filesize\ =\ 40M/g" /usr/local/etc/php/php.ini

RUN sed -i -e"s/^exec\s*apache2-foreground/#exec apache2-foreground/" /tmp/docker_run.sh
RUN service mysql start && /tmp/docker_run.sh
RUN sed -i -e"s/^#exec\s*apache2-foreground/exec apache2-foreground/" /tmp/docker_run.sh

COPY config_files/build/shop-build.php /tmp/build/shop-build.php
RUN service mysql start \
  && runuser -g www-data -u www-data -- php /tmp/build/shop-build.php \
  && runuser -g www-data -u www-data -- php -d memory_limit=-1 bin/console cache:warmup --env=prod

CMD ["/tmp/docker-customization_run.sh"]
