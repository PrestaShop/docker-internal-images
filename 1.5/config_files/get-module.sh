#!/bin/bash

# Handle zip download 1.7
displayStatusMessage() {
    local curl_error=$1

    case $curl_error in
        1|3) 
            Message="The URL was not properly formatted or the URL protocol is not supported (curlCode ${curl_error})."
        ;;
        2|4)
          Message="This is likely to be an internal error or feature is not built-in (curlCode ${curl_error})."
        ;;
        5|6|7)
          Message="Couldn't resolve host/proxy or failed to connect() to host/proxy (curlCode ${curl_error})."
        ;;
        *)
          Message="Error check man curl (curlCode ${curl_error})"
        ;;
    esac

    echo "${Message}"
}

# Slipt id in list
IFS=', ' read -r -a ID_MODULE_LIST <<< "$ID_MODULE"

for index in "${!ID_MODULE_LIST[@]}"
do
    echo "\n* Requesting module ${ID_MODULE_LIST[index]} ...";
    curl -u ${GET_USER} ${GET_FILE_MODULE}${ID_MODULE_LIST[index]} -L >> /var/www/html/modules/module.zip

    CMD_STATUS_CODE=$?
    if [ ${CMD_STATUS_CODE} != 0 ]
    then
        displayStatusMessage ${CMD_STATUS_CODE}
    else
        if [ ! -f /var/www/html/modules/module.zip ] || [ ! -s /var/www/html/modules/module.zip ]
        then
             echo "\n* Unable to download module ${ID_MODULE_LIST[index]} ..."
        else
            echo "\n* Unzipping the module ${ID_MODULE_LIST[index]} ...";
            unzip -q /var/www/html/modules/module.zip -d /var/www/html/modules/
            chown -R www-data:www-data /var/www/html/modules/
            rm /var/www/html/modules/module.zip
        fi
    fi
    echo "\n"
done
