#!/bin/bash

echo "\n* Requesting module $ID_MODULE ...";
curl "$GET_FILE_MODULE$ID_MODULE" >> /var/www/html/modules/module.zip
echo "\n* Unzipping the module ...";
unzip -q module.zip -d /var/www/html/modules/
rm /var/www/html/modules/module.zip

