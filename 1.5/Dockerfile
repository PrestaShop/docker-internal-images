FROM prestashop/prestashop:1.5

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

COPY config_files/my-minimal.cnf /etc/mysql/conf.d/my-minimal.cnf
COPY config_files/docker-customization_run.sh /tmp/docker-customization_run.sh
COPY config_files/get-module.sh /tmp/get-module.sh
RUN chmod u+x /tmp/docker-customization_run.sh /tmp/get-module.sh


RUN sed -i -e"s/^exec\s*apache2-foreground/#exec apache2-foreground/" /tmp/docker_run.sh
RUN /tmp/docker_run.sh
RUN sed -i -e"s/^#exec\s*apache2-foreground/exec apache2-foreground/" /tmp/docker_run.sh

CMD ["/tmp/docker-customization_run.sh"]
