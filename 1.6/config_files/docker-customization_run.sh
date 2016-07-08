#!/bin/bash

echo "\n* Starting MySQL server ...";
service mysql start

echo "\n* Updating PrestaShop domains ...";
req='UPDATE ps_configuration SET value = "'$PS_DOMAIN'" WHERE name IN ("PS_SHOP_DOMAIN", "PS_SHOP_DOMAIN_SSL"); UPDATE ps_shop_url SET domain = "'$PS_DOMAIN'", domain_ssl = "'$PS_DOMAIN'";'
mysql -h $DB_SERVER -P $DB_PORT -u $DB_USER -p$DB_PASSWD -D$DB_NAME -e "${req}"

if [ $PS_ADDONS_MODULE -ne 0 ]; then
	echo "\n* Requesting module $PS_ADDONS_MODULE ...";
	# Insert code to execute here
fi

bash /tmp/docker_run.sh
