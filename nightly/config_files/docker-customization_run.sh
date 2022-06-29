#!/bin/bash

echo "\n* Starting MySQL server ...";
service mysql start

echo "\n* Updating PrestaShop domains ...";
req='UPDATE ps_configuration SET value = "'$PS_DOMAIN'" WHERE name IN ("PS_SHOP_DOMAIN", "PS_SHOP_DOMAIN_SSL"); UPDATE ps_shop_url SET domain = "'$PS_DOMAIN'", domain_ssl = "'$PS_DOMAIN'";'
mysql -h$DB_SERVER -P$DB_PORT -u$DB_USER -p$DB_PASSWD -D$DB_NAME -e "${req}" &

req='UPDATE ps_configuration SET value = "'$PS_ENABLE_SSL'" WHERE name IN ("PS_SSL_ENABLED", "PS_SSL_ENABLED_EVERYWHERE");'
mysql -h$DB_SERVER -P$DB_PORT -u$DB_USER -p$DB_PASSWD -D$DB_NAME -e "${req}" &

php /tmp/update-domain.php &

if [ "$ID_MODULE" != "0" ]; then
	echo "\n* Requesting module $ID_MODULE ...";
	runuser -g www-data -u www-data bash /tmp/get-module.sh&
fi

unset GET_USER
unset GET_FILE_MODULE

bash /tmp/docker_nightly_run.sh
