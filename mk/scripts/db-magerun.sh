#!/usr/bin/env bash

# Include all variables from .env file.
[ -f app/etc/.env ] && source app/etc/.env
[ -f .env ] && source .env
[ -f app/etc/.env.${APP_ENV} ] && source app/etc/.env.${APP_ENV}
[ -f .env.${APP_ENV} ] && source .env.${APP_ENV}

# Verify required values are available.
required_values=(REMOTE_SERVER_IP REMOTE_SERVER_USER REMOTE_SERVER_PATH)
for required_value in ${required_values[@]}; do
    [ -z ${!required_value} ] && echo "${required_value} is missing!" && exit
done

# Use MAGERUN_STRIP value, if it does not exist use default values
MAGERUN_STRIP="${MAGERUN_STRIP:-@2fa @aggregated @customers @idx @log @oauth @quotes @replica @sales @search @sessions @stripped @trade @temp}"
REMOTE_SERVER_PORT="${REMOTE_SERVER_PORT:-22}"
REMOTE_MAGERUN="${REMOTE_MAGERUN:-magerun2}"
if [ "$FORCE_ONLINE_MAGERUN" = true ] ; then
    REMOTE_MAGERUN="curl https://files.magerun.net/n98-magerun2-latest.phar -s --output /tmp/magerun2 > /dev/null && ${REMOTE_PHP:-php} /tmp/magerun2"
fi

echo "Downloading database from remote and stripping '${MAGERUN_STRIP}'"
ssh -p $REMOTE_SERVER_PORT $REMOTE_SERVER_USER@$REMOTE_SERVER_IP "cd ${REMOTE_SERVER_PATH}; ${REMOTE_MAGERUN} db:dump --strip=\"${MAGERUN_STRIP}\" --exclude=\"${MAGERUN_EXCLUDE}\" --stdout 2> /dev/null" > dump.sql
magerun2 db:import dump.sql
rm dump.sql
