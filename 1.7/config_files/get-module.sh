#!/bin/bash

# Unset ENV variables - conflict during Module installation
#
PS_DEV_MODE_ORIGIN=${PS_DEV_MODE}
unset PS_DEV_MODE
PS_DEMO_MODE_ORIGIN=${PS_DEMO_MODE}
unset PS_DEMO_MODE


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

installModule() {
    local moduleName=$1

    echo "\n* Installing module $moduleName ..."
    php bin/console prestashop:module install $moduleName
    php bin/console prestashop:module configure $moduleName
}

# Split id_module in list
IFS=', ' read -r -a ID_MODULE_LIST <<< "$ID_MODULE"
# Split module_name_toinstall in list
IFS=', ' read -r -a MODULE_NAME_TOINSTALL_LIST <<< "$MODULE_NAME_TOINSTALL"

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
            unzip -o -q /var/www/html/modules/module.zip -d /var/www/html/modules/
            if [ "$MODULE_NAME_TOINSTALL" == "ALL" ]
            then
                MODULE_NAME=$(basename $( \
                unzip -l modules/module.zip 2>&1 \
                | grep -E '^\s+[0-9]+\s+[0-9-]+\s+[0-9:]+' \
                | awk -F' ' '{print $4}'| head -1
                            )
                    )
                installModule ${MODULE_NAME}
            fi
            rm /var/www/html/modules/module.zip
        fi
    fi
    echo "\n"
done

# Module installation block 
#
if [ "$MODULE_NAME_TOINSTALL" == "ALL" ]
then
	echo "\n* Modules have already been installed [ All option ]"
else
	for index in "${!MODULE_NAME_TOINSTALL_LIST[@]}"
	do
		if [  -d "modules/${MODULE_NAME_TOINSTALL_LIST[index]}" ] 
		then
			installModule ${MODULE_NAME_TOINSTALL_LIST[index]}
		else
			echo "\n* module ${MODULE_NAME_TOINSTALL_LIST[index]} is not present on modules directory ..."
		fi
	done
fi

# Restore ENV variables
export PS_DEV_MODE=${PS_DEV_MODE_ORIGIN}
unset PS_DEV_MODE_ORIGIN
export PS_DEMO_MODE=${PS_DEMO_MODE_ORIGIN}
unset PS_DEMO_MODE_ORIGIN

