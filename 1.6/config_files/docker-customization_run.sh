#!/bin/bash

echo "\n* Starting MySQL server ...";
service mysql start

echo "\n* Updating PrestaShop domains ...";
req='UPDATE ps_configuration SET value = "'$PS_DOMAIN'" WHERE name IN ("PS_SHOP_DOMAIN", "PS_SHOP_DOMAIN_SSL"); UPDATE ps_shop_url SET domain = "'$PS_DOMAIN'", domain_ssl = "'$PS_DOMAIN'";'
mysql -h $DB_SERVER -P $DB_PORT -u $DB_USER -p$DB_PASSWD -D$DB_NAME -e "${req}"

if [ $ID_MODULE -ne 0 ]; then
	echo "\n* Requesting module $ID_MODULE ...";
	curl "$GET_FILE_MODULE$ID_MODULE" >> /var/www/html/modules/module.zip
	echo "Unzip the module";
	cd /var/www/html/modules/
	unzip -q module.zip
	cd /var/www/html
fi

bash /tmp/docker_run.sh
