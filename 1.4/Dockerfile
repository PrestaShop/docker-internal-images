FROM prestashop/prestashop:1.4

MAINTAINER Thomas Nabord <thomas.nabord@prestashop.com>

ENV PS_ADDONS_MODULE 0
ENV PS_ADDONS_USER 0

ENV PS_HANDLE_DYNAMIC_DOMAIN 1
ENV PS_INSTALL_AUTO 1
ENV PS_DEV_MODE 1
ENV PS_ADMIN_FOLDER admin-dev
ENV PS_INSTALL_FOLDER install-dev
ENV DB_SERVER 127.0.0.1

# MySQL installation
# Avoid MySQL questions during installation
ENV DEBIAN_FRONTEND noninteractive
RUN echo mysql-server-5.6 mysql-server/root_password password $DB_PASSWD | debconf-set-selections
RUN echo mysql-server-5.6 mysql-server/root_password_again password $DB_PASSWD | debconf-set-selections
RUN apt-get update \
	&& apt-get install -y mysql-server \
    && rm -rf /var/lib/apt/lists/*
# MySQL configuration
RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf
EXPOSE 3306

RUN MYSQLD_STARTUP_TIMEOUT=900 service mysql start \
	&& mysqladmin -h $DB_SERVER -P $DB_PORT -u $DB_USER -p$DB_PASSWD create $DB_NAME --force

COPY config_files/docker-customization_run.sh /tmp/

RUN sed -i -e"s/^exec\s*apache2\s*-DFOREGROUND/#exec apache2 -DFOREGROUND/" /tmp/docker_run.sh
RUN service mysql start && /tmp/docker_run.sh
RUN sed -i -e"s/^#exec\s*apache2\s*-DFOREGROUND/exec apache2 -DFOREGROUND/" /tmp/docker_run.sh

CMD ["/tmp/docker-customization_run.sh"]
