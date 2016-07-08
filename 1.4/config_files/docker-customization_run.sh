#!/bin/bash

if [ $PS_ADDONS_MODULE -ne 0 ]; then
	echo "\n* Requesting module $PS_ADDONS_MODULE ...";
	# Insert code to execute here
fi

bash /tmp/docker_run.sh
