FROM prestashop/prestashop:1.7

MAINTAINER Thomas Nabord <thomas.nabord@prestashop.com>

ENV GET_USER ""
ENV GET_FILE_MODULE ""
ENV ID_MODULE 0

ENV PS_HANDLE_DYNAMIC_DOMAIN 0
ENV PS_INSTALL_AUTO 1
ENV PS_DEV_MODE 1
ENV PS_COUNTRY fr
ENV PS_FOLDER_ADMIN admin-dev
ENV PS_FOLDER_INSTALL install-dev
ENV DB_SERVER localhost
ENV DB_USER macfly

# MySQL installation
# Avoid MySQL questions during installation
ENV DEBIAN_FRONTEND noninteractive
RUN echo mysql-server-5.6 mysql-server/root_password password $DB_PASSWD | debconf-set-selections
RUN echo mysql-server-5.6 mysql-server/root_password_again password $DB_PASSWD | debconf-set-selections
RUN apt update \
  && apt install -y mysql-server \
  && rm -rf /var/lib/apt/lists/*
# MySQL configuration
RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf
EXPOSE 3306

RUN echo '[mysql.server]\nservice-startup-timeout = -1' >> /etc/mysql/conf.d/startup.cnf
RUN service mysql start \
&& mysql -e "CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWD'; GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'localhost'; FLUSH PRIVILEGES;" mysql \
	&& mysqladmin -h $DB_SERVER -P $DB_PORT -u $DB_USER -p$DB_PASSWD create $DB_NAME --force

COPY config_files/my-minimal.cnf /etc/mysql/conf.d/my-minimal.cnf
COPY config_files/docker-customization_run.sh /tmp/docker-customization_run.sh
COPY config_files/get-module.sh /tmp/get-module.sh
RUN chmod u+x /tmp/docker-customization_run.sh /tmp/get-module.sh


RUN sed -i -e"s/^exec\s*apache2-foreground/#exec apache2-foreground/" /tmp/docker_run.sh
RUN service mysql start && /tmp/docker_run.sh
RUN sed -i -e"s/^#exec\s*apache2-foreground/exec apache2-foreground/" /tmp/docker_run.sh

CMD ["/tmp/docker-customization_run.sh"]
