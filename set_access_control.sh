#!/bin/bash
ATTEMPTS=0
echo "Waiting for rancher..."
until curl --fail -s -X GET -H "Accept: application/json" "$4/v2-beta/localauthconfig" ; do
  if ((ATTEMPTS >= 2000 )) ; then 
  	exit
  fi
  ATTEMPTS=$[$ATTEMPTS+1]
  echo "Rancher not yet up, retrying..."
  sleep 1
done
echo "\nSetting rancher access control."
curl -X POST -H "Content-Type: application/json" -H "Accept: application/json" -d "\
{\
\"id\": null,\
\"type\": \"localAuthConfig\",\
\"baseType\": \"localAuthConfig\",\
\"accessMode\": \"unrestricted\",\
\"enabled\": true,\
\"name\": \"$1\",\
\"password\": \"$2\",\
\"username\": \"$3\"\
}" \
"$4/v2-beta/localauthconfig"
echo "done."