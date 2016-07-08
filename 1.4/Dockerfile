FROM prestashop/prestashop:1.4

MAINTAINER Thomas Nabord <thomas.nabord@prestashop.com>

ENV PS_ADDONS_MODULE 0
ENV PS_ADDONS_USER 0

ENV PS_HANDLE_DYNAMIC_DOMAIN 1
ENV PS_INSTALL_AUTO 1
ENV PS_DEV_MODE 1
ENV PS_ADMIN_FOLDER admin-dev
ENV PS_INSTALL_FOLDER install-dev

COPY config_files/docker-customization_run.sh /tmp/

RUN sed -i -e"s/^exec\s*apache2\s*-DFOREGROUND/#exec apache2 -DFOREGROUND/" /tmp/docker_run.sh
RUN /tmp/docker_run.sh
RUN sed -i -e"s/^#exec\s*apache2\s*-DFOREGROUND/exec apache2 -DFOREGROUND/" /tmp/docker_run.sh

CMD ["/tmp/docker-customization_run.sh"]
