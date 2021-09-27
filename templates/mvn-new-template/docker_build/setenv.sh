#!/bin/sh


echo ${APP_ENV}
HOSTNAME_=`hostname`
echo ${HOSTNAME_}
HOSTNAME_=${HOSTNAME_##*-}
echo ${HOSTNAME_}

  sed -i "s|pinpoint.applicationName=.*$|pinpoint.applicationName=$APP_ENV\_$APP_ID\"|" /setPP.sh
  sed -i "s|pinpoint.agentId=.*$|pinpoint.agentId="${APP_ID}"\_"${HOSTNAME_}"\"|" /setPP.sh
  . "setPP.sh"

echo ${CATALINA_OPTS}