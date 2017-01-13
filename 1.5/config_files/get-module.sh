#!/bin/bash

echo "\n* Requesting module $ID_MODULE ...";
curl -u ${GET_USER} $GET_FILE_MODULE$ID_MODULE -L >> /var/www/html/modules/module.zip
echo "\n* Unzipping the module ...";
unzip -q /var/www/html/modules/module.zip -d /var/www/html/modules/
chown -R www-data:www-data /var/www/html/modules/
rm /var/www/html/modules/module.zip
